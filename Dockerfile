FROM alpine:3.13.0
CMD ["/bin/sh"]
RUN apk update && apk add ipmitool mosquitto-clients
CMD ["wget" "https://github.com/kushpatel000/IPMI2MQTT/blob/6b0f37cff0b9a0d41e1b9b79886a041a06d61cd6/ipmi_script.sh"]
RUN echo '*/$UPDATE_INTERVAL_MIN * * * * ./ipmi_script.sh' > /etc/crontabs/root
CMD ["/usr/sbin/crond" "-l" "2" "-f"]
