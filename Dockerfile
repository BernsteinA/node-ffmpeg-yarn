FROM node:6-alpine

RUN apk update
RUN apk add ffmpeg curl bash binutils tar git
RUN touch ~/.bashrc
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN apk del curl tar binutils
RUN rm -rf /var/cache/apk/*
