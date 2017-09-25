FROM node:6-alpine

RUN apk update
RUN apk add ffmpeg git libpng-dev
RUN rm -rf /var/cache/apk/*
