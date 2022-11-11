[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

# Basement

Music player with the ability to download tracks from YouTube

---

To run server you should use docker-compose.

Create `.env` file with the following content in project directory:

```
POSTGRES_USER=<your postgres user>
POSTGRES_PASSWORD=<your postgres user password>
POSTGRES_DB=postgres
LISTEN_PORT=<port which application will listen on>
LISTEN_HOST=<host which application will listen on>
POSTGRES_EXTERNAL_PORT=<port on which postgres will be available from outer world>
```

Then run following command in project directory:

```
sudo docker-compose build && sudo docker-compose up -d
```
