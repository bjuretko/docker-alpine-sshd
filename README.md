# docker-alpine-sshd

Small helper alpine-based image with glibs support to join a docker host via ssh.
Default listening port is 2223.
Usable as a vscode ssh remote.

## Build

```sh
docker build -t sshd https://github.com/bjuretko/docker-alpine-sshd.git#main:docker
```

or

```sh
docker build -t sshd --pull --no-cache .
```

### VSCode SSH remote extension

The Dockerfile describes a multi-stage image which can be used as a remote ssh container for vscode.

Run the following modified to the host environment in the sshd container:

```sh
USER=benedict
USERID=1000
GROUP=users
AUTHORIZED_KEYS_URL=https://github.com/bjuretko.keys
adduser -h /home/${USER} -G ${GROUP} -u ${USERID} -D ${USER} && \
   passwd -u ${USER} && \
   cd /home/${USER} && \
   mkdir .ssh && \
   wget -O .ssh/authorized_keys ${AUTHORIZED_KEYS_URL} && \
   chown -R ${USER}:${GROUP} .ssh
```

or copy it to `sshduser.sh`.

## Run

```sh
sudo docker run -it --rm --name sshd_dev -v "$(pwd)/..:/repos" -v sshd:/etc/ssh -p 2223:2223 sshd && sudo docker exec sshd_dev /repos/docker-alpine-sshd/sshduser.sh
```

## Tweaks

Finetune the behaviour of sshd start

### Use another listening port for sshd

Just use another mapping:

```sh
docker run --rm -it --name sshd2224 -p 2224:2223 sshd
```

But if you have port conflict (e.g. because of using host network), you can pass arugment flags to sshd:

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

Update parameter `PermitRootLogin` in `/etc/ssh/sshd_config` to `yes` to allow root login or use it as runtime parameter with `-o PermitRootLogin=yes`.

### Reuse sshd host keys and settings

The known host will change on every container creation, which may lead to error messages like:

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ED25519 key sent by the remote host is
SHA256:.
Please contact your system administrator.
Add correct host key in .ssh/known_hosts to get rid of this message.
Offending ECDSA key in .ssh/known_hosts:13
Password authentication is disabled to avoid man-in-the-middle attacks.
Keyboard-interactive authentication is disabled to avoid man-in-the-middle attacks.
UpdateHostkeys is disabled because the host key is not trusted.
```

You will need to update the known_host file or disable `StrictHostKeyChecking` in the ssh config file.
Use a shared docker volume to persist the keys.

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
