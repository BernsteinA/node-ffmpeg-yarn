FROM node:6-alpine

RUN apk update
RUN apk add ffmpeg
RUN apk add curl
RUN apk add bash
RUN apk add binutils
RUN apk add tar

RUN rm -rf /var/cache/apk/*

RUN curl -o- -L https://yarnpkg.com/install.sh | bash

RUN apk del curl tar binutils
