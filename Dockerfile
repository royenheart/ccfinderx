# FROM ubuntu:20.04
FROM ubuntu:18.04

USER root

WORKDIR /ccfinderx

# ubuntu:20.04
# RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt install -y libboost-all-dev libtool autoconf automake make build-essential autoconf-archive python python3 libpython3.8-dev python3-dev python-dev libicu-dev libicu66 icu-devtools openjdk-8-jdk
# ubuntu:18.04
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y libboost-all-dev libtool autoconf automake make build-essential autoconf-archive python python3 libpython3.6-dev python3-dev python-dev libicu-dev icu-devtools openjdk-8-jdk

COPY . .

WORKDIR /ccfinderx

RUN libtoolize && aclocal -I m4 --install && autoconf && automake --foreign --add-missing && ./configure --prefix=/ccfinderx/ccfinderx
RUN make -j 2>&1 | tee build.log || echo "Ignore first try build"
RUN g++ -g -O2 -o ccfx/ccfx common/ccfx_ccfx-base64encoder.o common/ccfx_ccfx-bitvector.o common/ccfx_ccfx-unportable.o common/ccfx_ccfx-utf8support.o ccfx/ccfx_ccfx-ccfx.o ccfx/ccfx_ccfx-ccfxcommon.o ccfx/ccfx_ccfx-prettyprintermain.o ccfx/ccfx_ccfx-rawclonepairdata.o ccfx/ccfx_ccfx-ccfxconstants.o  -L/usr/lib/x86_64-linux-gnu -licui18n -licuuc -licudata -licuio -lboost_thread -lboost_system
RUN make install