FROM ciscotalos/snort3:latest
USER root
COPY start-msg /tmp/start-msg
RUN cat /tmp/start-msg >> /home/snorty/.bashrc && rm /tmp/start-msg
RUN touch /lib/x86_64-linux-gnu/libcap2/tests/exploit
RUN echo "INFO: If you see an 'overlay2 ... no such file or directory' libcap2/tests/exploit error after build: this is a harmless bug in the upstream base image."
USER snorty
