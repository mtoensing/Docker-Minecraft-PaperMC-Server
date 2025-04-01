# Docker Minecraft JAVA PaperMC Server

![](https://img.shields.io/github/license/mtoensing/Docker-Minecraft-papermc-Server.svg)
![](https://img.shields.io/github/stars/mtoensing/Docker-Minecraft-papermc-Server)
![](https://img.shields.io/docker/v/marctv/minecraft-papermc-server)
![](https://img.shields.io/docker/stars/marctv/minecraft-papermc-server.svg)
![](https://img.shields.io/docker/pulls/marctv/minecraft-papermc-server.svg)
![](https://img.shields.io/docker/image-size/marctv/minecraft-papermc-server.svg)

Docker Minecraft PaperMC server for AMD64 and ARM64 platforms.
Works on Synology, Raspberry Pi or any other systems that support docker.

Always up-to-date with the latest PaperMC version.

## Quick Start

```sh
docker run --name mcserver --memory=4g -v /home/joe/mcserver:/data:rw -p 25565:25565 -i marctv/minecraft-papermc-server:latest
```

The server will generate all data including the world and config files in `/home/joe/mcserver`. Change that to an
existing folder.

## Docker Run Command

```shell
docker run -d \
  --name mcserver \
  --restart=unless-stopped \
  --memory=1g \
  -p 25565:25565/tcp \
  -p 25565:25565/udp \
  -v /home/docker/mcserver:/data:rw \
  marctv/minecraft-papermc-server:latest
```

## Docker Compose (Portainer Stacks)

```yaml
services:
  minecraft:
    image: marctv/minecraft-papermc-server:latest
    restart: always
    container_name: "mcserver"
    environment:
      PAPERMC_FLAGS: ""
    deploy:
      resources:
        limits:
          memory: 1G
    volumes:
      - minecraftserver:/data
    ports:
      - "25565:25565"
    # The following allow `docker attach minecraft` to work
    stdin_open: true
    tty: true

volumes:
  minecraftserver:
```

## How do I update the container?

### On Synology DSM

- Re-download the image from the docker repository.
- Stop the container.
- Clear the container.
- Start the container.

### On Terminal

```sh
docker pull marctv/minecraft-papermc-server:latest
docker stop mcserver
```

Or just use https://containrrr.dev/watchtower/

## User Permissions

This container runs as a fixed non-root user with UID/GID 9001:9001. When mounting volumes, make sure your directories have the correct permissions.

### Setting Permissions for Mounted Volumes

If you encounter permission issues with mounted volumes (especially when migrating from an existing installation), you can adjust permissions using a temporary busybox container:

```sh
docker run --rm -v /path/to/your/data:/data busybox chown -R 9001:9001 /data
```

This avoids permission-related problems without needing to run the main container with elevated privileges.

## Docker Compose

If you prefer to use `docker compose`, use the following commands:

Start the server:

```shell
docker compose up
```

Stop the server:

```shell
docker compose stop
```

Issue server commands after attaching to the container:

```shell
docker attach mcserver
# then you can type things like "list"
list
# which will show the current players online or
help
# to see all the commands available
```

## How to use the Makefile with Docker Compose

Additionally, a `Makefile` is provided to easily start, stop, and attach to the container.

```shell
make start     # equivalent to `docker compose up -d --build`
make stop      # equivalent to `docker compose stop --rmi all --remove-orphans`
make attach    # equivalent to `docker attach mcserver`
make help      # prints a help message
```

## Environment variables

### Memory

`MEMORYSIZE = 1G`

Not more than 70% of your RAM for your container. This is important. Because this is the RAM, your Minecraft Server will
use within the container WITHOUT the operating system.

But don't use this unless you really need this. Use runtime memory limits.

### Timezone

`TZ = Europe/Berlin`

Sets the timezone for the container. A list of valid values can be found on
Wikipedia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

### Additional flags

`PAPERMC_FLAGS = --nojline`

Optional: Sets the command-line flags for PaperMC. Remove `--nojline` if you want to enable color and tab-completion for
the server console.

`JAVAFLAGS`

Optional: Overrides the optimized java parameter configuration with your own. You can set your own Xms and Xmx values
this way.

## Tutorial Synology

Tutorial (german) https://marc.tv/anleitung-stabiler-minecraft-server-synology-nas/

[![Watch the video](https://img.youtube.com/vi/LtAQiTwLgak/maxresdefault.jpg)](https://youtu.be/LtAQiTwLgak)

https://youtu.be/LtAQiTwLgak

## How-to install on a Raspberry Pi 4

### Video Tutorial Raspberry Pi 4

[![Watch the video](https://img.youtube.com/vi/BuHOyhM2fCg/maxresdefault.jpg)](https://youtu.be/BuHOyhM2fCg)

https://youtu.be/BuHOyhM2fCg

### How-to install on a Raspberry Pi 4

You can install this docker container by using my dedicated
installer: https://github.com/mtoensing/RaspberryPiMinecraftDocker Or just follow these steps:

1. Download **Raspberry Pi Imager** https://www.raspberrypi.com/software/ and start it.
2. Select Raspberry Pi OS **lite** (64-bit) under "Raspberry Pi OS (other)".
3. Click on gear icon in the Raspberry Pi Imager and enable ssh and set username and password.
4. Write image to a fast sd card.
5. Connect the Raspberry Pi 4 to an ethernet cable.
6. Use putty for Windows or terminal on macOS and connect via ssh:

```sh
ssh pi@raspberrypi
```

7. Upgrade all packages

```sh
 sudo apt update && sudo apt upgrade
 sudo reboot now
```

The Raspberry Pi will restart now.

8. Install Docker

```sh
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
./get-docker.sh
sudo apt-get install -y uidmap
dockerd-rootless-setuptool.sh install
sudo usermod -aG docker $USER
sudo systemctl enable docker
newgrp docker
```

9. New folder for the server

```sh
cd
mkdir mcserver
```

10. Run this image as Minecraft Server

```sh
docker run -d \
--restart unless-stopped \
--name mcserver \
--memory=1g \
-e PAPERMC_FLAGS='' \
-v /home/pi/mcserver:/data:rw \
-p 25565:25565 \
-it docker.io/marctv/minecraft-papermc-server:latest
```

The server will generate all data including the world and config files in `/home/pi/mcserver`.

11. Enter the command line of Minecraft server

```sh
docker attach mcserver
```

Here, you can use Minecraft server commands like `whitelist add [userrname]`.

## Credits

On GitHub https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server

This server is live here: https://mc.marc.tv

Based on the work of [Felix Klauke](https://github.com/FelixKlauke/paperspigot-docker) Thanks for your help!
