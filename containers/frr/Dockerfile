FROM alpine:latest

COPY start.sh /start.sh
RUN apk add --no-cache busybox-extras frr ethtool && \
  mkdir /config && \
  chmod 700 /start.sh && \
  echo "service integrated-vtysh-config" >>/etc/frr/vtysh.conf && \
  touch /etc/frr/frr.conf && chmod 777 /etc/frr/frr.conf && \
  chmod 777 /etc/frr

ENTRYPOINT [ "/start.sh" ]

