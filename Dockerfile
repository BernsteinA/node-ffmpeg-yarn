FROM node:6-alpine

RUN apk update
RUN apk add ffmpeg

# for yarn, I think
RUN apk add git

# https://github.com/imagemin/imagemin/issues/168#issuecomment-265545957
RUN apk add libpng-dev autoconf automake make g++ libtool nasm

# https://github.com/HaxeFoundation/docker-library-haxe/blob/master/3.2/alpine3.6/Dockerfile

# ensure local haxe is preferred over distribution haxe
ENV PATH /usr/local/bin:$PATH

# install ca-certificates so that HTTPS works consistently
# the other runtime dependencies are installed later
RUN apk add --no-cache ca-certificates

ENV NEKO_VERSION 2.1.0
ENV HAXE_VERSION 3.2.1

RUN set -ex \
	&& apk add --no-cache --virtual .fetch-deps \
		libressl \
		tar \
		git \
	\
	&& wget -O neko.tar.gz "http://nekovm.org/media/neko-2.1.0-src.tar.gz" \
	&& echo "0c93d5fe96240510e2d1975ae0caa9dd8eadf70d916a868684f66a099a4acf96 *neko.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/src/neko \
	&& tar -xC /usr/src/neko --strip-components=1 -f neko.tar.gz \
	&& rm neko.tar.gz \
	&& wget -O /usr/src/neko/xlocale.patch "https://raw.githubusercontent.com/alpinelinux/aports/v3.6.2/testing/neko/compilation-fixes.patch" \
	&& echo "d13fe905a0425d1ce0ec126aa3abc1940944572b92b72ec22d1e670623863949  /usr/src/neko/xlocale.patch" | sha256sum -c - \
	&& apk add --no-cache --virtual .build-deps \
		apache2-dev \
		cmake \
		gc-dev \
		gcc \
		gtk+2.0-dev \
		libc-dev \
		linux-headers \
		mariadb-dev \
		mbedtls-dev \
		ninja \
		sqlite-dev \
		patch \
	&& cd /usr/src/neko \
	&& patch -p 1 < xlocale.patch \
	&& cmake -GNinja -DRELOCATABLE=OFF -DRUN_LDCONFIG=OFF . \
	&& ninja \
	&& ninja install \
	\
	&& git clone --recursive --depth 1 --branch 3.2.1 "https://github.com/HaxeFoundation/haxe.git" /usr/src/haxe \
	&& apk add --no-cache --virtual .build-deps \
		camlp4 \
		ocaml \
		pcre-dev \
		zlib-dev \
		make \
	&& cd /usr/src/haxe \
	&& make OCAMLOPT=ocamlopt.opt \
	&& make install INSTALL_DIR=/usr/local \
	\
	&& runDeps="$( \
		scanelf --needed --nobanner --recursive /usr/local \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	&& apk add --virtual .python-rundeps $runDeps \
	&& apk del .build-deps \
	&& apk del .fetch-deps \
	\
	&& cd / && haxelib setup /usr/local/lib/haxe/lib

RUN rm -rf /var/cache/apk/*
