FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  bash iproute2 iputils-ping net-tools mtr-tiny iperf3 traceroute fping \
  sensible-utils curl telnet netcat-openbsd socat snmp termshark \
  openssh-client vim nano less jq yq httpie procps dnsutils bash dhcping nmap && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY mibs.tar.gz /
RUN tar zxvf mibs.tar.gz && rm mibs.tar.gz
COPY motd /etc/motd
RUN echo "cat /etc/motd" >> /root/.bashrc

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
