FROM golang:1.18.4-alpine3.15 AS build

ENV GO111MODULE=on
ENV CGO_ENABLED=0 
ENV GOOS=linux
ENV GOARCH=amd64

WORKDIR /server

COPY go.mod go.sum ./
RUN go mod download

COPY ./ ./
RUN go build -o server

FROM alpine:3.15.5
RUN apk add --no-cache ffmpeg python3
RUN wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/youtube-dl
RUN chmod +x /usr/local/bin/youtube-dl

WORKDIR /server

RUN mkdir ./music
COPY --from=build ./server ./

CMD [ "./server" ]

LABEL name="backend"
