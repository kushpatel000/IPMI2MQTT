FROM alpine:3.13.0

CMD ["/bin/sh"]

RUN apk update && apk add ipmitool mosquitto-clients wget
RUN wget https://raw.githubusercontent.com/kushpatel000/IPMI2MQTT/main/ipmi_script.sh
RUN chmod +x ipmi_script.sh

RUN echo '*/$UPDATE_INTERVAL_MIN * * * * ./ipmi_script.sh' > /etc/crontabs/root
CMD ["/usr/sbin/crond", "-l", "2", "-f"]
