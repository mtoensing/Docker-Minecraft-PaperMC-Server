docker run \
  --rm \
  --name mcserver \
  -v /var/services/homes/mtoensing/server:/data:rw \
  -p 25565:25565 \
-i minecraftpaperserver:latest
