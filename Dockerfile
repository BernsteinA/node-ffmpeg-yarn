FROM node:6-alpine

RUN apk update
RUN apk add ffmpeg

# for yarn, I think
RUN apk add git

# https://github.com/imagemin/imagemin/issues/168#issuecomment-265545957
RUN apk add libpng-dev autoconf automake make g++ libtool nasm

# https://github.com/Level/leveldown/issues/388
RUN apk add python
RUN npm install -g --build-from-source leveldown
RUN apk del python

RUN rm -rf /var/cache/apk/*
