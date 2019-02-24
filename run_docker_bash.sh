docker run \
  --rm \
  --name mcserver \
  --entrypoint=/bin/bash \
  -v ~/server:/data:rw \
  -p 25565:25565 \
  -itd marctv/minecraftpaperserver:latest
