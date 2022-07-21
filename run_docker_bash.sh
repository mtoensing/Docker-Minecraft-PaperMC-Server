docker run \
  --rm \
  --name mcserver \
  --entrypoint=/bin/bash \
  -v /Users/mtoe/Documents/mcserver:/data:rw \
  -p 25566:25565 \
-i marctv/minecraft-papermc-server:beta
