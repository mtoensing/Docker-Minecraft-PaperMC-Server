# Docker Minecraft JAVA PaperMC Server 1.19

Docker Minecraft PaperMC server for 1.19, 1.18, 1.17 for AMD64 and ARM64 platforms. Works on Synology, Raspberry Pi 4 or any other systems that support docker.

[![Build and push](https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server/actions/workflows/dockerimage.yml/badge.svg?branch=master&event=push)](https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server/actions/workflows/dockerimage.yml)

## Quick Start

```sh
docker run --rm --name mcserver -e MEMORYSIZE='1G' -v /home/joe/mcserver:/data:rw -p 25565:25565 -i marctv/minecraft-papermc-server:latest
```
The server will generate all data including the world and config files in ``/home/joe/mcserver``. Change that to an existing folder.

## How-to install on a Raspberry Pi 4

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
```
8. Install Docker 
```sh
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh 
./get-docker.sh 
apt-get install -y uidmap
dockerd-rootless-setuptool.sh install
sudo usermod -aG docker $USER
newgrp docker
```
9. New folder for the server
```sh
cd 
mkdir mcserver
```
10. Run this image as Minecraft Server
```sh
docker run -d --rm --name mcserver -e MEMORYSIZE='1G' -e PAPERMC_FLAGS='' -v /home/pi/mcserver:/data:rw -p 25565:25565 -it marctv/minecraft-papermc-server:latest
```
The server will generate all data including the world and config files in ``/home/pi/mcserver``.

11. Enter the command line of Minecraft server
```sh
docker attach mcserver
```
Here, you can use Minecraft server commands like ``whitelist add [userrname]``.

## How do I update the container? 

### On Synology DSM

* Re-download the image from the docker repository.
* Stop the container.
* Clear the container.
* Start the container.

### On Terminal

```sh
docker pull marctv/minecraft-papermc-server:latest
sudo docker stop mcserver
```

## Run as non-root user

You can get the desired UID/GID (xxx) with the ID command (id username) then add the following to your docker run command:

```sh
-e PUID=xxx
-e PGID=xxx
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

Sets the command-line flags for PaperMC. Remove `--nojline` if you want to enable color and tab-completion for the server console.

## Tutorial

Tutorial (german) https://marc.tv/anleitung-stabiler-minecraft-server-synology-nas/

[![Watch the video](https://img.youtube.com/vi/LtAQiTwLgak/maxresdefault.jpg)](https://youtu.be/LtAQiTwLgak)

https://youtu.be/LtAQiTwLgak

## Credits

On GitHub https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server

This server is live here: https://mc.marc.tv

Based on the work of [Felix Klauke](https://github.com/FelixKlauke/paperspigot-docker) Thanks for your help!
