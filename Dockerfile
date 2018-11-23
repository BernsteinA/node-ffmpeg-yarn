FROM node:8-stretch

RUN apt-get update
RUN apt-get install -y ffmpeg

# for yarn, I think
RUN apt-get install -y git

# https://github.com/imagemin/imagemin/issues/168#issuecomment-265545957
RUN apt-get install -y libpng-dev autoconf automake make g++ libtool nasm
