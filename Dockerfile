FROM alpine:3.16 AS sshd-image
# see https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.authors="Benedict Juretko"
LABEL org.opencontainers.image.source="https://github.com/bjuretko/docker-alpine-sshd"

ENTRYPOINT ["/entrypoint.sh"]
# expose to port 2223 by default
EXPOSE 2223
CMD ["-p 2223"]

COPY README.md entrypoint.sh /
RUN apk add --update --no-cache openssh

# install necessary dependencies for vscode remote ssh extension
FROM sshd-image AS vscode-remote-image
CMD ["-p 2223", "-o AllowTcpForwarding=yes"]
VOLUME /etc/ssh
RUN apk add --update --no-cache gcompat libstdc++ curl bash git
