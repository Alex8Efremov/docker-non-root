FROM php:8.1.6-fpm-alpine3.16

COPY . .

RUN apk add supervisor dcron libcap

RUN mkdir /app && \
    cat crontab > /etc/crontabs/rise && \
    touch /var/log/cron.log && \
    cp supervisord-cron.conf /etc/ && \
    addgroup -S rise && adduser -S rise -G rise && \
    chown -R rise:rise /usr/sbin/crond /app /etc/crontabs /var/log && \
    setcap cap_setgid=ep /usr/sbin/crond
# if crond don't running, try to add busybox capabilities
#RUN setcap cap_setgid=ep /bin/busybox && chown rise:rise /bin/busybox

USER rise
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord-cron.conf" ]
