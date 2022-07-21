docker run \
  --rm \
  --name mcserver \
  -e MEMORYSIZE='1G' \
  -v /volume2/SSD/mcserver-beta:/data:rw \
  -p 25566:25565 \
-i marctv/minecraft-papermc-server:beta
docker attach mcserver
