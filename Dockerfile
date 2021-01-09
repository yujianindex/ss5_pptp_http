FROM alpine:3.12
MAINTAINER yu 
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache iptables wget bash tzdata && \
    cd / && wget http://dl-cdn.alpinelinux.org/alpine/edge/testing/x86_64/lrzsz-0.12.20-r1.apk  && \
    apk add lrzsz-0.12.20-r1.apk && \
    rm -f lrzsz-0.12.20-r1.apk && \
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
	apk del tzdata

COPY ./data/3proxy /bin/
COPY ./data/*.ld.so /usr/local/3proxy/libexec/

RUN mkdir -p /usr/local/3proxy/logs &&\
    mkdir -p /usr/local/3proxy/conf &&\
    mkdir -p /usr/local/3proxy/limit &&\
    mkdir -p /usr/local/3proxy/traf &&\
    chmod +x   /bin/3proxy &&\
    chmod -R 755 /usr/local/3proxy/libexec &&\
    chown -R root /usr/local/3proxy/libexec &&

CMD syslogd -n -O /dev/stdout
