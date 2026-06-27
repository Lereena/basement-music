#!/usr/bin/env python3
"""Soulseek daemon.

Long-running aioslsk client that:
  * connects to the Soulseek network with credentials passed via env vars,
  * shares the local music library so we stay share-ratio compliant,
  * exposes a small local HTTP API (aiohttp) the Go server talks to.

The HTTP server binds to 127.0.0.1 only -- it is never exposed to the
internet. The Go `SoulseekWorker` launches this process and proxies requests.

Env vars:
  SLSK_USERNAME   Soulseek account username
  SLSK_PASSWORD   Soulseek account password
  MUSIC_PATH      directory to share + write downloads into
  SLSK_PORT       HTTP port to listen on (default 19876)

Endpoints:
  GET  /status          -> {"connected": bool, "connecting": bool, "error": str, "username": str, "shared_files": int}
  POST /search          {"query": "..."} -> [ {result}, ... ]
  POST /download        {"username","filename","output"} -> {"ok": true}
  POST /refresh-shares  -> {"ok": true, "shared_files": int}
"""

import asyncio
import logging
import os
import shutil
import sys

from aiohttp import web

try:
    from aioslsk.client import SoulSeekClient
    from aioslsk.settings import Settings, CredentialsSettings
    from aioslsk.search.model import SearchRequest
    try:
        from aioslsk.settings import SharedDirectorySettingEntry
    except ImportError:  # older/newer schema variants
        SharedDirectorySettingEntry = None
except ImportError as exc:  # pragma: no cover - dependency missing
    print(f"aioslsk import failed: {exc}", file=sys.stderr)
    raise

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [slsk-daemon] %(levelname)s %(message)s",
)
log = logging.getLogger("slsk-daemon")

SEARCH_TIMEOUT = 15  # seconds to collect peer responses


class Daemon:
    def __init__(self, username: str, password: str, music_path: str):
        self.username = username
        self.password = password
        self.music_path = music_path
        self.client: SoulSeekClient | None = None
        self.connected = False
        self.connecting = False
        self.error = ""
        self._lock = asyncio.Lock()

    def _share_entries(self):
        """Build shared-directory entries in whatever shape this aioslsk wants."""
        if SharedDirectorySettingEntry is not None:
            try:
                return [SharedDirectorySettingEntry(path=self.music_path)]
            except Exception:
                pass
        # Fallback: pydantic models also accept plain dicts.
        return [{"path": self.music_path}]

    def _temp_dir(self) -> str:
        return os.path.join(self.music_path, "slsk_temp")

    def _build_settings(self) -> Settings:
        settings = Settings(
            credentials=CredentialsSettings(
                username=self.username,
                password=self.password,
            )
        )
        # Direct aioslsk to download into our temp dir (same filesystem as music_path).
        try:
            settings.transfers.download_dir = self._temp_dir()
        except Exception:
            pass
        try:
            settings.downloads.download_dir = self._temp_dir()
        except Exception:
            pass
        # Share the music library so peers can browse/download from us.
        try:
            settings.shares.directories = self._share_entries()
        except Exception as exc:
            log.warning("Could not set shared directories on settings: %s", exc)
        return settings

    async def start(self):
        self.connecting = True
        self.error = ""
        try:
            settings = self._build_settings()
            self.client = SoulSeekClient(settings)
            await self.client.start()
            await self.client.login()
            self.connected = True
            log.info("Connected to Soulseek as %s", self.username)
            await self.refresh_shares()
        except Exception as exc:
            self.error = str(exc)
            self.connected = False
            log.error("Failed to connect to Soulseek: %s", exc)
            raise
        finally:
            self.connecting = False

    async def stop(self):
        if self.client is not None:
            try:
                await self.client.stop()
            except Exception as exc:  # pragma: no cover
                log.warning("Error stopping client: %s", exc)
        self.connected = False

    async def shared_file_count(self) -> int:
        if self.client is None:
            return 0
        try:
            items = await self.client.shares.get_shared_items()
            return len(items)
        except Exception:
            return 0

    async def refresh_shares(self) -> int:
        if self.client is None:
            return 0
        try:
            self.client.settings.shares.directories = self._share_entries()
            await self.client.shares.scan()
            log.info("Shares rescanned")
        except Exception as exc:  # pragma: no cover
            log.warning("Share rescan failed: %s", exc)
        return await self.shared_file_count()

    async def search(self, query: str) -> list[dict]:
        """Try a few query variants, return a flat list of files across peers."""
        if self.client is None:
            return []

        results: list[dict] = []
        async with self._lock:
            request: SearchRequest = await self.client.searches.search(query)
            await asyncio.sleep(SEARCH_TIMEOUT)

            for peer_result in request.results:
                username = getattr(peer_result, "username", "")
                free_slots = bool(getattr(peer_result, "has_free_slots", False))
                speed = int(getattr(peer_result, "avg_speed", 0) or 0)

                shared = getattr(peer_result, "shared_items", None) or getattr(
                    peer_result, "results", []
                )
                for item in shared:
                    filename = getattr(item, "filename", "") or ""
                    ext = filename.rsplit(".", 1)[-1].lower() if "." in filename else ""
                    bitrate = 0
                    attrs = getattr(item, "attributes", None) or []
                    for attr in attrs:
                        # attribute 0 is bitrate in the Soulseek protocol
                        if getattr(attr, "key", None) in (0, "bitrate"):
                            bitrate = int(getattr(attr, "value", 0) or 0)
                    results.append(
                        {
                            "username": username,
                            "filename": filename,
                            "extension": ext,
                            "bitrate": bitrate,
                            "size": int(getattr(item, "filesize", 0) or 0),
                            "free_slots": free_slots,
                            "speed": speed,
                        }
                    )

        log.info("Search '%s' -> %d files", query, len(results))
        return results

    async def download(self, username: str, filename: str, output: str, timeout: int = 120):
        if self.client is None:
            raise RuntimeError("not connected")

        os.makedirs(os.path.dirname(output), exist_ok=True)
        transfer = await self.client.transfers.download(username, filename)

        # Poll transfer.state until terminal; aioslsk has no wait_for_transfer helper.
        deadline = asyncio.get_event_loop().time() + timeout
        while asyncio.get_event_loop().time() < deadline:
            state_name = type(transfer.state).__name__
            if "Complete" in state_name:
                break
            if any(s in state_name for s in ("Failed", "Aborted", "Error")):
                raise RuntimeError(f"Transfer {state_name}: {transfer.state}")
            await asyncio.sleep(0.5)
        else:
            raise RuntimeError("Transfer timed out")

        local = getattr(transfer, "local_path", None)
        if local and os.path.abspath(local) != os.path.abspath(output):
            shutil.move(local, output)


def make_app(daemon: Daemon) -> web.Application:
    app = web.Application()

    async def status(_request):
        return web.json_response(
            {
                "connected": daemon.connected,
                "connecting": daemon.connecting,
                "error": daemon.error,
                "username": daemon.username,
                "shared_files": await daemon.shared_file_count(),
            }
        )

    async def search(request):
        body = await request.json()
        query = (body or {}).get("query", "").strip()
        if not query:
            return web.json_response({"error": "empty query"}, status=400)
        try:
            results = await daemon.search(query)
        except Exception as exc:
            log.exception("search failed")
            return web.json_response({"error": str(exc)}, status=500)
        return web.json_response(results)

    async def download(request):
        body = await request.json()
        username = (body or {}).get("username")
        filename = (body or {}).get("filename")
        output = (body or {}).get("output")
        if not all([username, filename, output]):
            return web.json_response({"error": "missing fields"}, status=400)
        try:
            await daemon.download(username, filename, output)
        except Exception as exc:
            log.warning("download failed: %s", exc)
            return web.json_response({"error": str(exc)}, status=502)
        return web.json_response({"ok": True})

    async def refresh_shares(_request):
        count = await daemon.refresh_shares()
        return web.json_response({"ok": True, "shared_files": count})

    app.router.add_get("/status", status)
    app.router.add_post("/search", search)
    app.router.add_post("/download", download)
    app.router.add_post("/refresh-shares", refresh_shares)
    return app


async def main():
    username = os.environ.get("SLSK_USERNAME", "")
    password = os.environ.get("SLSK_PASSWORD", "")
    music_path = os.environ.get("MUSIC_PATH", "./music")
    port = int(os.environ.get("SLSK_PORT", "19876"))

    if not username or not password:
        log.error("SLSK_USERNAME and SLSK_PASSWORD are required")
        sys.exit(1)

    daemon = Daemon(username, password, music_path)

    # Start the HTTP API first so the Go worker can poll /status (including the
    # error reason) even while the connection attempt is still in flight or fails.
    app = make_app(daemon)
    runner = web.AppRunner(app)
    await runner.setup()
    site = web.TCPSite(runner, "127.0.0.1", port)
    await site.start()
    log.info("HTTP API listening on 127.0.0.1:%d", port)

    try:
        await daemon.start()
    except Exception:
        pass  # error captured in daemon.error and reported via /status

    try:
        await asyncio.Event().wait()  # run forever
    finally:
        await daemon.stop()
        await runner.cleanup()


if __name__ == "__main__":
    asyncio.run(main())
