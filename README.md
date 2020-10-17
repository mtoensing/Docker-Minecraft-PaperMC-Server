# Docker Minecraft PaperMC Server 1.16

Docker Minecraft PaperMC server 1.16.3, 1.15.2, 1.14.4 (legacy) or 1.13.2 (legacy)

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

## Volume

You can use volumes to store data persistantly, for example:

```sh
docker run --rm \
	-p 25565:25565 \
	-v <full path to folder where you want to store the server files>:/data:rw \
	marctv/minecraft-papermc-server:latest
 ```

## Environment variable

MEMORYSIZE = 1G

Not more than 70% of your RAM for your Container! This is important! This is the RAM your Minecraft Server will use within the container WITHOUT the operating system.

## Tutorial

Tutorial (german) https://marc.tv/anleitung-stabiler-minecraft-server-synology-nas/

[![Watch the video](https://img.youtube.com/vi/LtAQiTwLgak/maxresdefault.jpg)](https://youtu.be/LtAQiTwLgak)

https://youtu.be/LtAQiTwLgak

## Credits

On GitHub https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server

This server is live here: https://mc.marc.tv

Based on the the work of [Felix Klauke](https://github.com/FelixKlauke/paperspigot-docker) Thanks for your help!
