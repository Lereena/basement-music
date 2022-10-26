FROM ubuntu:latest AS build

WORKDIR /root/flutter

RUN apt-get update && apt-get install -y curl xz-utils git

ARG FLUTTER_SDK_LINK=https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.3.5-stable.tar.xz
RUN curl $FLUTTER_SDK_LINK --output flutter.tar.xz
RUN tar -xf flutter.tar.xz
ENV PATH="$PATH:/root/flutter/flutter/bin"
RUN git config --global --add safe.directory /root/flutter/flutter

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY ./ ./
RUN flutter build web

FROM nginxinc/nginx-unprivileged:1.19-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /app

EXPOSE 8080