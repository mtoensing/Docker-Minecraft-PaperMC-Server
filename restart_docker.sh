#!/bin/sh
# Marc Tönsing - V1.2 - 18.05.2018
# Minecraft Server restart
echo "Starting countdown via rcon-cli."
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver say Server is restarting in 30 seconds!
sleep 23s
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver say Server is restarting in 7 seconds!
sleep 1s
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver say Server is restarting in 6 seconds!
sleep 1s
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver say Server is restarting in 5 seconds!
sleep 1s
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver say Server is restarting in 4 seconds!
sleep 1s
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver say Server is restarting in 3 seconds!
sleep 1s
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver say Server is restarting in 2 seconds!
sleep 1s
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver say Server is restarting in 1 second!
sleep 1s
echo "Stopping server."
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver say Closing server...
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver stop
sleep 15s
echo "Restarting now."
./run_docker.sh
