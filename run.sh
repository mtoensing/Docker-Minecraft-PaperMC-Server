docker run \
  --rm \
  --name mcserver \
  -v ~/server:/data:rw \
  -p 25565:25565 \
  -itd minecraftpaperserver:latest
