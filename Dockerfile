FROM node:6-alpine

RUN apk update
RUN apk add ffmpeg

# for yarn, I think
RUN apk add git

# https://github.com/imagemin/imagemin/issues/168#issuecomment-265545957
RUN apk add libpng-dev autoconf automake make g++ libtool nasm tar wget

ARG OPTIPNG_VERSION=0.7.6

RUN mkdir -p /usr/src/optipng /source \
    && wget -O - https://sourceforge.mirrorservice.org/o/op/optipng/OptiPNG/optipng-${OPTIPNG_VERSION}/optipng-${OPTIPNG_VERSION}.tar.gz | tar xz -C /usr/src/optipng --strip-components=1 \
    && cd /usr/src/optipng \
    && ./configure \
    && make \
    && make install \
    && rm -rf /usr/src/optipng
      
RUN apk del tar wget

RUN rm -rf /var/cache/apk/*

RUN npm install -g optipng-bin

RUN ln -fs /usr/local/bin/optipng /usr/local/lib/node_modules/optipng-bin/vendor/optipng
