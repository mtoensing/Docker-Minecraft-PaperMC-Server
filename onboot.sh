#!/bin/bash
docker_autostart(){
pscheck="$(ps -ef |  grep -v grep | grep docker | awk \"{print $2}\")"
rundocker="/var/services/homes/mtoensing/Minecraft-Paper-Server/run_docker.sh"

if [ ! -n "$pscheck" ]; then
    eval $rundocker
fi
}

export -f docker_autostart
su root -c "docker_autostart"
