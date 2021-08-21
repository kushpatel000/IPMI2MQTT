CMD["/bin/sh"]
RUN apk update && apk add ipmitool mosquitto-clients
RUN echo '*/$UPDATE_INTERVAL_MIN * * * * ./ipmi_script.sh' > /etc/crontabs/root
CMD["/usr/sbin/crond" "-l" "2" "-f"]
