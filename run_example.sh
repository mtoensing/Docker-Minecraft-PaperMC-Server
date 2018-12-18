docker build -t minecraftpaperserver .
docker run \
  --rm \
  -v ~/server:/data:rw \
  -p 25565:25565 \
  -it minecraftpaperserver:latest




# --entrypoint=/bin/bash \
