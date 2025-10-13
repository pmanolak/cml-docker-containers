FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends flow-tools && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir -p /var/flowdata

CMD ["flow-capture", "-w/var/flowdata", "0/0/3000", "-S1", "-d1", "-D"]

