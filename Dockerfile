# Use Alpine Linux
FROM alpine:latest

env TZ "Asia/Shanghai"

ADD repositories /etc/apk/repositories
RUN apk update && \
    apk upgrade && \
    apk --update add tar curl

# Caddy executable
RUN curl "https://caddyserver.com/download/build?os=linux&arch=amd64&features=cors" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy

#Remove curl tar
RUN apk del curl tar openssl ca-certificates libssh2 && \
    rm -rf /var/cache/apk/*

EXPOSE 80 443
VOLUME /srv
WORKDIR /srv


# Caddyfile
ONBUILD ADD Caddyfile /etc/Caddyfile
ONBUILD ADD ./srv /srv

ONBUILD ENTRYPOINT ["/usr/bin/caddy"]
ONBUILD CMD ["--conf", "/etc/Caddyfile"]





