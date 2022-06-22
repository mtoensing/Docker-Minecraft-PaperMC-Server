# Docker Minecraft JAVA PaperMC Server 1.19

Docker Minecraft PaperMC server for 1.19, 1.18, 1.17 and 1.16 (deprecated!)

# Minecraft 1.19

	docker pull marctv/minecraft-papermc-server:1.19

See https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server/issues/33 for more information.

## Quick Start
```sh
docker pull marctv/minecraft-papermc-server
```

```sh
docker run \
  --rm \
  --name mcserver \
  -e MEMORYSIZE='1G' \
  -v /homes/joe/mcserver:/data:rw \
  -p 25565:25565 \
-i marctv/minecraft-papermc-server:latest
```
```sh
docker attach mcserver
```

## How do I update the container? 

* Re-download the image from the docker
* Stop the container
* Clear the container
* Start the container

## Volume

You can use volumes to store data persistantly, for example:

```sh
docker run --rm \
	-p 25565:25565 \
	-v <full path to folder where you want to store the server files>:/data:rw \
	marctv/minecraft-papermc-server:latest
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

## Environment variable

MEMORYSIZE = 1G

Not more than 70% of your RAM for your Container! This is important! This is the RAM your Minecraft Server will use within the container WITHOUT the operating system.

TZ = Europe/Berlin 

Sets the timezone for the container. A list of valid values can be found on wikipedia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

PAPERMC_FLAGS = --nojline

Sets the command-line flags for PaperMC. Remove `--nojline` if you want to enable color and tab-completion for the server console.

## Tutorial

Tutorial (german) https://marc.tv/anleitung-stabiler-minecraft-server-synology-nas/

[![Watch the video](https://img.youtube.com/vi/LtAQiTwLgak/maxresdefault.jpg)](https://youtu.be/LtAQiTwLgak)

https://youtu.be/LtAQiTwLgak

## Credits

On GitHub https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server

This server is live here: https://mc.marc.tv

Based on the the work of [Felix Klauke](https://github.com/FelixKlauke/paperspigot-docker) Thanks for your help!
