# my-py2.7

## Create development image

### 1. Build "py2.7-dev" docker image

```bash
task build
```

After the image is built, list the "py2.7" image,

```bash
docker images | grep py2.7

py2.7-dev         latest           10e84e2626e0   9 seconds ago   329MB
```

### 2. Run containers

```bash
task up
```

Display launched containers

```bash
docker ps -a


CONTAINER ID   IMAGE              COMMAND               CREATED         STATUS         PORTS                                          NAMES
f8dc4ba33f2e   py2.7-dev:latest   "/usr/sbin/sshd -D"   5 seconds ago   Up 3 seconds   0.0.0.0:8787->8787/tcp, 0.0.0.0:2222->22/tcp   py2.7
```

### 3. SSH to "py2.7" container

Attempt to SSH into the "py2.7" container,

```bash
task login
```

After the connection is successful, a password is required.

You can use `authorized_key` for SSH login,

```bash
ssh-copy-id -p 2222 root@127.0.0.1
```

Try SSH login again,

```bash
task login
```

### 4. Get into "py2.7" container

```bash
task exec
```

### 5. Install python requirement packages

Install necessary packages

```bash
cd /srv &&\
pip install pip -U &&\
pip install pycurl -U &&\
pip install -r ./requirement.txt
```

Once you finish modifying the new container, exit out of it:

```bash
exit
```

List all launched containers,

```bash
docker ps -a

CONTAINER ID   IMAGE              COMMAND               CREATED         STATUS         PORTS                                          NAMES
f8dc4ba33f2e   py2.7-dev:latest   "/usr/sbin/sshd -D"   2 minutes ago   Up 2 minutes   0.0.0.0:8787->8787/tcp, 0.0.0.0:2222->22/tcp   py2.7
```

Copy the CONTAINER ID that you save changes.

### 6. Commit changes to image

Create a new image by committing the changes using the following syntax,

```bash
docker commit [CONTAINER ID] [new_image_name]
```

In our example it will be,

```bash
docker commit f8dc4ba33f2e my-py2.7-dev
```

You can verify by checking the image list again:

```bash
docker images | grep py2.7

my-py2.7-dev      latest           cd7c2ab0d9b3   6 seconds ago    453MB
py2.7-dev         latest           10e84e2626e0   16 minutes ago   329MB
```

### 7. Use new images

Remove all launched containers,

```bash
task down
```

Modify the `docker-compose.yml`, and change `image: py2.7-dev:latest` to `image: my-py2.7-dev:latest`.

Run containers again,

```bash
task up
```

List all launched containers,

```bash
docker ps -a

CONTAINER ID   IMAGE                 COMMAND               CREATED              STATUS              PORTS                                          NAMES
f462db97314f   my-py2.7-dev:latest   "/usr/sbin/sshd -D"   About a minute ago   Up About a minute   0.0.0.0:8787->8787/tcp, 0.0.0.0:2222->22/tcp   py2.7
```

-----

## Useful docker commands

Get IP Address of container

```bash
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' py2.7
```

Use `docker` command to run container

```bash
docker run -td --name py2.7 \
         -p "8787:8787" \
         -p "2222:22" \
         -v $PWD:/srv \
         -w /srv \
         my-py2.7-dev:latest

```

## References

1. [Use ssh-copy-id with an OpenSSH Server Listening On a Different Port](https://www.cyberciti.biz/faq/use-ssh-copy-id-with-an-openssh-server-listing-on-a-different-port/)
2. [Ssh-copy-id for copying SSH keys to servers](https://www.ssh.com/academy/ssh/copy-id)
3. [How to Commit Changes to a Docker Image with Examples](https://phoenixnap.com/kb/how-to-commit-changes-to-docker-image)
