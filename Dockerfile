FROM gliderlabs/alpine:3.2

# RUN apk add shadow --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# RUN /usr/sbin/groupadd -r redis && /usr/sbin/useradd -r -g redis redis
RUN addgroup redis && adduser -s /bin/bash -D -G redis redis

RUN apk add --update curl redis bash && sed -i 's/daemonize yes/daemonize no/g' /etc/redis.conf 

# grab gosu for easy step-down from root
RUN curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" && chmod +x /usr/local/bin/gosu

RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

EXPOSE 6379
CMD [ "gosu", "redis", "redis-server", "/etc/redis.conf" ]
