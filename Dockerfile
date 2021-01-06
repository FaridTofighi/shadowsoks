#
# Dockerfile for shadowsocks-libev
#
FROM golang
RUN cd /tmp/ \
    && git clone https://github.com/shadowsocks/shadowsocks-libev.git \
    && git clone https://github.com/shadowsocks/v2ray-plugin.git \
    && cd v2ray-plugin \
    && go build \
    && cd /tmp/shadowsocks-libev/ \
    && git submodule update --init --recursive

FROM alpine
LABEL maintainer="kev <noreply@datageek.info>, Sah <contact@leesah.name>"

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD=
ENV METHOD      aes-256-gcm
ENV TIMEOUT     300
ENV DNS_ADDRS    8.8.8.8,8.8.4.4
ENV TZ UTC
ENV ARGS=

COPY --from=0 /tmp/shadowsocks-libev /tmp/repo
RUN apk update
RUN apk add --no-cache libc6-compat
RUN set -ex \
 # Build environment setup
 && apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      libcap \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      pcre-dev \
 # Build & install
 && cd /tmp/repo \
 && ./autogen.sh \
 && ./configure --prefix=/usr --disable-documentation \
 && make install \
 && ls /usr/bin/ss-* | xargs -n1 setcap cap_net_bind_service+ep \
 && apk del .build-deps \
 # Runtime dependencies setup
 && apk add --no-cache \
      ca-certificates \
      rng-tools \
      tzdata \
      $(scanelf --needed --nobanner /usr/bin/ss-* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
 && rm -rf /tmp/repo
COPY --from=0 /tmp/v2ray-plugin/v2ray-plugin /usr/local/bin/
RUN chmod +x /usr/local/bin/v2ray-plugin
#USER nobody

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
