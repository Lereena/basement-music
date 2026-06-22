FROM golang:1.25.0-alpine AS build

ENV GO111MODULE=on
ENV CGO_ENABLED=0 
ENV GOOS=linux
ENV GOARCH=amd64

WORKDIR /server

COPY go.mod go.sum ./
RUN go mod download

COPY ./ ./
RUN go build -o server

FROM alpine:3.19
RUN apk add --no-cache ffmpeg python3 py3-pip
RUN wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/youtube-dl
RUN chmod +x /usr/local/bin/youtube-dl

# Soulseek daemon dependencies
RUN pip3 install --no-cache-dir --break-system-packages aioslsk==1.1.3 aiohttp

WORKDIR /server

RUN mkdir ./music
COPY --from=build ./server ./
COPY soulseek_daemon.py ./

CMD [ "./server" ]

LABEL name="backend"
