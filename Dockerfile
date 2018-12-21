# by aspirin2d
FROM alpine:latest as builder

MAINTAINER aspirin2d <sleep2death@gmail.com>

# Thanks for MaYun Baba
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

WORKDIR /tmp

# Install dependencies
RUN apk add --no-cache \
    build-base \
    ctags \
    git \
    libx11-dev \
    libxpm-dev \
    libxt-dev \
    make \
    ncurses-dev \
    lua-dev

# Build vim from git source
RUN git clone --depth 1 https://github.com/vim/vim \
 && cd vim \
 && ./configure \
    --disable-gui \
    --disable-netbeans \
    --enable-multibyte \
    --enable-luainterp \
    --with-features=big \
 && make install

FROM alpine:latest

# Thanks for MaYun Baba
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

ENV NeoComplPATH="/usr/local/share/vim/vimfiles/pack/plugins/start/neocomplete.vim"

COPY --from=builder /usr/local/bin/ /usr/local/bin
COPY --from=builder /usr/local/share/vim/ /usr/local/share/vim/
# NOTE: man page is ignored

RUN apk add --no-cache \
    diffutils \
    libice \
    libsm \
    libx11 \
    libxt \
    libstdc++ \
    ncurses \
    lua \
    git \
# Download Ycm
    && git clone --depth 1 https://github.com/Shougo/neocomplete.vim.git $NeoComplPATH \
# Cleanup
    && rm -rf \
    /var/cache/* \
    /var/log/* \
    /var/tmp/* \
    && find . | grep "\.git/" | xargs rm -rf \

