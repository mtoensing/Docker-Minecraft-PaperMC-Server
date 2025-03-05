FROM eclipse-temurin:21-jdk

ARG DOWNLOAD_URL

# download paperclip
ADD "${DOWNLOAD_URL}" /opt/minecraft/paperspigot.jar

# add rcon-cli
COPY --from=docker.io/itzg/rcon-cli:latest /rcon-cli /usr/local/bin/rcon-cli

# install dependencies
RUN apt update && apt install -y gosu webp adduser && rm -rf /var/lib/apt/lists/*

# Expose minecraft port
EXPOSE 25565/tcp 25565/udp

# define environment variables
ENV MEMORYSIZE="1G"
ENV JAVAFLAGS="-Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true"
ENV PAPERMC_FLAGS="--nojline"

VOLUME /data

WORKDIR /data

COPY /docker-entrypoint.sh /opt/minecraft

RUN chmod +x /opt/minecraft/docker-entrypoint.sh

# Entrypoint
ENTRYPOINT ["/opt/minecraft/docker-entrypoint.sh"]
