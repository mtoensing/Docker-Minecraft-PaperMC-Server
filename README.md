# Docker-Minecraft-PaperMC-Server

Starts a Minecraft PaperMC server 1.15.2, 1.14.4 (legacy) or 1.13.2 (legacy) 

Tutorial (german) https://marc.tv/anleitung-stabiler-minecraft-server-synology-nas/

On GitHub https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server

This server is live here: https://mc.marc.tv

Based on the the work of [Felix Klauke](https://github.com/FelixKlauke/paperspigot-docker) Thanks for your help!

## Quick Start

docker pull marctv/minecraft-papermc-server

docker run \
  --rm \
  --name mcserver \
  -e MEMORYSIZE='1G' \
  -v /homes/joe/mcserver:/data:rw \
  -p 25565:25565 \
  -p 25575:25575 \
-i marctv/minecraft-papermc-server:latest
docker attach mcserver

## Volume

Local path: /your_local_folder
Mount path: /data

## Port Settings

Local Port: 25565 TCP
Container Port: 25565 TCP

Local Port: 25565 UDP
Container Port: 25565 UDP

## Environment variable

MEMORYSIZE = 1G 

Not more than 70% of your RAM for your Container! This is important! This is the RAM your Minecraft Server will use within the container WITHOUT the operating system.

## How to install this server on a Synology NAS

[![Watch the video](https://img.youtube.com/vi/LtAQiTwLgak/maxresdefault.jpg)](https://youtu.be/LtAQiTwLgak)
