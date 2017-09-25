FROM node:6-alpine

RUN apk update
RUN apk add ffmpeg

# for yarn, I think
RUN apk add git

# for pngquant, gifsicle, mozjpeg, and cwebp (aka image-webpack-loader)
RUN apk add libpng-dev build-base autoconf libtool nasm

RUN rm -rf /var/cache/apk/*
