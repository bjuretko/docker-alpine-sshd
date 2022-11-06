FROM alpine:latest
# see https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.authors="Benedict Juretko"
LABEL org.opencontainers.image.source="https://github.com/bjuretko/docker-alpine-sshd"

ENTRYPOINT ["/entrypoint.sh"]
# expose to port 2223 by default
EXPOSE 2223
CMD ["-p 2223"]

COPY README.md entrypoint.sh /
RUN apk add --update --no-cache openssh