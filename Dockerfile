FROM alpine:3.20.6

COPY 10-my-cni.conf /cni/10-my-cni.conf
COPY my-cni /cni/my-cni
COPY entrypoint.sh /cni/entrypoint.sh
RUN chmod +x /cni/my-cni
RUN chmod +x /cni/entrypoint.sh

ENTRYPOINT ["/cni/entrypoint.sh"]
