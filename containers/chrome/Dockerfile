FROM debian:bookworm-slim

ARG uid
ARG version

RUN test -n "${uid}" || (echo "docker build-arg uid must be set" && false)

COPY google-chrome.gpg /usr/share/keyrings/google-chrome.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >/etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  software-properties-common \
  apt-transport-https \
  curl ca-certificates \
  i3 \
  xdotool \
  google-chrome-stable=${version} && \
  apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* && \
  useradd -l --create-home --shell /bin/bash -u ${uid} --user-group debian
COPY i3config /home/debian/.config/i3/config
RUN mkdir -p /var/run/dbus && \
  ln -s /home/debian/.dbus-socket /var/run/dbus/system_bus_socket && \
  chown -R debian:debian /home/debian/.config /var/run/dbus/system_bus_socket

USER debian
COPY start.sh /start.sh
CMD ["/start.sh"]

