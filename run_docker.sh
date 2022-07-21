docker run \
  --rm \
  --name mcserver \
  -e MEMORYSIZE='1G' \
  -v /Users/mtoe/Documents/mcserver:/data:rw \
  -p 25565:25565 \
  -p 25575:25575 \
-i marctv/minecraft-papermc-server:latest
docker attach mcserver
