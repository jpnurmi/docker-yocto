ARG BASE=ubuntu:22.04

FROM ${BASE}

ARG GID=1000
ARG UID=1000
ARG USER=user

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    abootimg \
    apt-file \
    bash-completion \
    bc \
    binutils \
    bison \
    build-essential \
    ca-certificates \
    ccache \
    chrpath \
    clang \
    clang-format \
    clang-tools \
    clangd \
    cmake \
    coreutils \
    cpio \
    curl \
    debianutils \
    diffstat \
    diffutils \
    default-jdk \
    dos2unix \
    dosfstools \
    file \
    findutils \
    flex \
    fzf \
    gawk \
    gcc-arm-none-eabi \
    gcc-multilib \
    g++-multilib \
    genext2fs \
    git \
    git-lfs \
    gnupg \
    gnutls-bin \
    gperf \
    gzip \
    hostname \
    imagemagick \
    iputils-ping \
    jq \
    lcov \
    lib32ncurses5-dev \
    lib32z1-dev \
    libarchive-zip-perl \
    libblkid-dev \
    libc6-dev-i386 \
    libclang-dev \
    libelf-dev \
    libgl1-mesa-dev \
    libgtk-3-dev \
    liblzma-dev \
    libsdl1.2-dev \
    libssl-dev \
    libtinfo5 \
    libx11-dev \
    libxcursor-dev \
    libxinerama-dev \
    libxml2-utils \
    libxrandr-dev \
    locales \
    lz4 \
    m4 \
    make \
    meson \
    mmv \
    moreutils \
    mtools \
    mtd-utils \
    nano \
    net-tools \
    ninja-build \
    openssl \
    pkg-config \
    python3 \
    python3-argcomplete \
    python3-pexpect \
    python3-pip \
    python3-requests \
    python3-rich \
    python3-setuptools \
    python-is-python3 \
    rar \
    ruby \
    scons \
    screen \
    socat \
    strace \
    stress \
    sudo \
    texinfo \
    tmux \
    tree \
    u-boot-tools \
    unrar \
    unzip \
    valgrind \
    wget \
    x11proto-core-dev \
    xsltproc \
    xterm \
    xz-utils \
    zip \
    zlib1g-dev \
    zstd

RUN apt-file update
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && sudo apt-get install nodejs -y
RUN npm install -g jake
RUN npm install -g pegjs

RUN ln -sf bash /bin/sh

RUN groupadd --gid ${GID} ${USER} && \
    useradd --no-create-home --shell /bin/bash --uid ${UID} --gid ${GID} ${USER} && \
    usermod -aG sudo ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER} && \
    mkdir -p /home/${USER} && \
    chown ${UID}:${GID} -R /home/${USER}

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

ENV HOME /home/${USER}
ENV USER ${USER}
USER ${UID}:${GID}
WORKDIR /home/${USER}
