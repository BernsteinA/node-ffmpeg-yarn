FROM node:6-alpine

RUN apk update
RUN apk add ffmpeg git libpng-dev build-base autoconf 
RUN rm -rf /var/cache/apk/*
