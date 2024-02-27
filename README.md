# Docker Minecraft JAVA PaperMC Server 1.20+

Docker Minecraft PaperMC server for 1.20, 1.19, 1.18, 1.17 for AMD64 and ARM64 platforms. Works on Synology, Raspberry Pi 4 or any other systems that support docker.

[![Build and push](https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server/actions/workflows/dockerimage.yml/badge.svg?branch=master&event=push)](https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server/actions/workflows/dockerimage.yml)

## Quick Start

```sh
docker run --rm --name mcserver -e MEMORYSIZE='1G' -v /home/joe/mcserver:/data:rw -p 25565:25565 -i marctv/minecraft-papermc-server:latest
```

The server will generate all data including the world and config files in `/home/joe/mcserver`. Change that to an existing folder.

## Docker Run Command
```shell
docker run -d \
  --name mcserver \
  --restart=unless-stopped \
  -e MEMORYSIZE="1G" \
  -p 25565:25565/tcp \
  -p 25565:25565/udp \
  -v /home/docker/mcserver:/data:rw \
  marctv/minecraft-papermc-server:latest
```
## Docker Compose (Portainer Stacks)

```shell
version: "3"
services:
  minecraft:
    image: marctv/minecraft-papermc-server:latest
    restart: always
    container_name: "mcserver"
    environment:
      MEMORYSIZE: "1G"
      PAPERMC_FLAGS: ""
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

## Run as non-root user

You can get the desired UID/GID (xxx) with the ID command (id username) then add the following to your docker run command:

```sh
-e PUID=xxx
-e PGID=xxx
```

### Skip permission change step

If you have a big custom minecraft install (e.g. multiple plugins which generate files), changing ownership can take up a
tremendous amount of time. You can skip this, by making sure that your files have the necessary permissions for the UID/GID
that you passed using the environment variables above and then add the following variable:

```sh
-e SKIP_PERM_CHECK=true
```

## Docker Compose

If you prefer to use `docker-compose`, use the following commands:

Start the server:

```sh
docker-compose up
```

Stop the server:

```sh
docker-compose stop
```

Issue server commands after attaching to the container:

```sh
docker attach mcserver
# then you can type things like "list"
list
# which will show the current players online or
help
# to see all the commands available
```

## How to use the Makefile with Docker Compose

Additionally, a `Makefile` is provided to easily start, stop, and attach to the container.

```sh
make start     # equivalent to `docker-compose up -d --build`
make stop      # equivalent to `docker-compose stop --rmi all --remove-orphans`
make attach    # equivalent to `docker attach mcserver`
make help      # prints a help message
```

## Environment variables

MEMORYSIZE = 1G

Not more than 70% of your RAM for your container. This is important. Because this is the RAM, your Minecraft Server will use within the container WITHOUT the operating system.

TZ = Europe/Berlin

Sets the timezone for the container. A list of valid values can be found on Wikipedia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

PAPERMC_FLAGS = --nojline

Optional: Sets the command-line flags for PaperMC. Remove `--nojline` if you want to enable color and tab-completion for the server console.

JAVAFLAGS 

Optional: Overrides the optimized java parameter configuration with your own. You can set your own Xms and Xmx values this way.

## Tutorial Synology

Tutorial (german) https://marc.tv/anleitung-stabiler-minecraft-server-synology-nas/

[![Watch the video](https://img.youtube.com/vi/LtAQiTwLgak/maxresdefault.jpg)](https://youtu.be/LtAQiTwLgak)

https://youtu.be/LtAQiTwLgak

## How-to install on a Raspberry Pi 4

### Video Tutorial Raspberry Pi 4

[![Watch the video](https://img.youtube.com/vi/BuHOyhM2fCg/maxresdefault.jpg)](https://youtu.be/BuHOyhM2fCg)

https://youtu.be/BuHOyhM2fCg

### How-to install on a Raspberry Pi 4

You can install this docker container by using my dedicated installer: https://github.com/mtoensing/RaspberryPiMinecraftDocker Or just follow these steps:

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
-e MEMORYSIZE='1G' \
-e PAPERMC_FLAGS='' \
-v /home/pi/mcserver:/data:rw \
-p 25565:25565 \
-it marctv/minecraft-papermc-server:latest
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