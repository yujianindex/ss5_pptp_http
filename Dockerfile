FROM alpine:3.12
MAINTAINER yu 

ARG VERSION=0.8.13

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache iptables ppp pptpd alpine-sdk wget bash squid && \
    cd / && wget http://dl-cdn.alpinelinux.org/alpine/edge/testing/x86_64/lrzsz-0.12.20-r1.apk  && \
    apk add lrzsz-0.12.20-r1.apk && \
    rm -f lrzsz-0.12.20-r1.apk 

COPY ./data/pptpd.conf    /etc/
COPY ./data/chap-secrets  /etc/ppp/
COPY ./data/pptpd-options /etc/ppp/
COPY ./data/3proxy /usr/bin/

#EXPOSE 1723

CMD set -xe \
    && iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE \
    && pptpd \
    && syslogd -n -O /dev/stdout
