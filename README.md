# docker-alpine-sshd

Small helper image to join a docker host via ssh.
Default listening port is 2223.

## Build

```sh
docker build https://github.com/bjuretko/docker-alpine-sshd.git#main:docker -t sshd
```

## Run

```sh
docker run --rm -it --name sshd2223 -p 2223:2223 sshd
```

## Tweaks

Finetune the behaviour of sshd start

### Use another listening port for sshd

Just use another mapping:

```sh
docker run --rm -it --name sshd2224 -p 2224:2223 sshd
```

But if you have port conflice (e.g. because of using host network), you can pass arugment flags to sshd:

```sh
docker run --rm -it --name sshd2224 -p 2224:2224 sshd -p 2224
```

### Add authorized_keys

Add my public keys from github:

```sh
docker exec sshd2223 mkdir /root/.ssh
docker exec sshd2223 wget -O /root/.ssh/authorized_keys https://github.com/bjuretko.keys
```

### Login via password

Enter the running container and change the password of user root via

```sh
docker exec -it sshd2223 sh
~ #  echo "root:thepasswordhere" | chpasswd
```

Update parameter `PermitRootLogin` in `/etc/ssh/sshd_config` to `yes` to allow root login.

### Reuse sshd host keys and settings

Use a shared docker volume

```sh
docker volume create --name sshd
docker run --rm -it -v sshd:/etc/ssh -p 2223:2223 --name sshd2223 sshd
```

Inspect the volume with:

```sh
docker volume inspect sshd
```

### Reuse container

In the previous calls the containers got pruned automatically after executioin by the `--rm` flag.
You can reuse a container by:

```sh
docker run -it -p 2223:2223 --name sshd2223 sshd
# exiting the container and later restart it with:
docker start -ai sshd2223
# remove container if not needed anymore
docker container rm sshd2223
```
