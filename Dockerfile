FROM ubuntu:22.04

# ENV TZ=Australia/Sydney
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get -y install wget tar openssl git make cmake \
    python3 python3-pip clang libsodium-dev autoconf automake \
    libtool yasm texinfo libboost-dev libssl-dev libboost-system-dev \
    libboost-thread-dev libgmp-dev rsync ssh openssh-server procps \
    pypy3

WORKDIR /root

ADD download.sh .
RUN ./download.sh

RUN git clone https://github.com/data61/MP-SPDZ
RUN cd MP-SPDZ; git checkout cd25c2e

RUN cd MP-SPDZ; make boost mpir

ADD build-mp-spdz.sh .
RUN ./build-mp-spdz.sh

ADD ssh_config .ssh/config
ADD setup-ssh.sh .
RUN ./setup-ssh.sh

ADD convert.sh *.py ./
RUN ./convert.sh

ADD *.sh *.py HOSTS ./
RUN ./run-local.sh emul 2 2
RUN service ssh start; ./run-remote.sh sh3 1 1
