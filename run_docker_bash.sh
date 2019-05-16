docker run \
  --rm \
  --name mcserver \
  --entrypoint=/bin/bash \
  -v /Users/mtoe/Documents/mcserver:/data:rw \
  -p 25565:25565 \
-i marctv/minecraft-papermc-server:latest
