#!/bin/sh
# Marc Tönsing - V1.2 - 18.05.2018
docker exec -i -t mcserver screen -Rd minecraft -X stuff "say Closing server...$(printf '\r')"
docker exec -i -t mcserver screen -Rd minecraft -X stuff "stop $(printf '\r')"
