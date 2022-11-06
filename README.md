# docker-alpine-sshd

Small helper image to join a docker host via ssh

## Build

```sh
docker build https://github.com/bjuretko/docker-alpine-sshd.git#main:docker -t sshd
```

## Run

```sh
docker run --rm -it ... sshd
```

## Tweaks

### Add authorized_keys

```sh
docker exec 
```

### Reuse container keys

Use a shared volume

```sh

```
