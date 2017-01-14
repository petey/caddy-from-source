# Caddy server from source
# Inspired by 
# * https://hub.docker.com/r/sapk/caddy/
# * https://hub.docker.com/r/abiosoft/caddy/

FROM alpine:latest
LABEL caddy_version="dev" architecture="amd64"

ENV GOPATH="/go"

RUN    apk -U --no-progress upgrade \
    && apk -U --force --no-progress add \
          build-tools go git ca-certificates musl-dev \
    && mkdir /go \
    && go get github.com/mholt/caddy/caddy \
    && mv /go/bin/caddy /usr/bin \
    && apk del --purge build-tools go git \
    && rm -rf $GOPATH /var/cache/apk/*

WORKDIR /srv
COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html

EXPOSE 80 443 2015
VOLUME     [ "/root/.caddy" ]
ENTRYPOINT [ "/usr/bin/caddy" ]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]