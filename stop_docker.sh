#!/bin/sh
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver say server will shut down
docker exec -i -t mcserver rcon-cli --port 25575 --password mcserver stop
