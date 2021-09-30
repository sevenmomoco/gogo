FROM alpine:latest
RUN apk add --no-cache --virtual .build-deps ca-certificates nginx curl wget unzip

#同步系统时间
RUN apk add tzdata
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
RUN apk del tzdata

RUN mkdir /tmp/v2ray
RUN curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
RUN unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
RUN install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
RUN install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
RUN rm -rf /tmp/v2ray

# V2Ray new configuration
RUN install -d /usr/local/etc/v2ray

RUN mkdir /run/nginx
ADD default.conf /etc/nginx/conf.d/default.conf

ADD index.html /var/lib/nginx/html/index.html


ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
EXPOSE 80
ENTRYPOINT ["/configure.sh"]
