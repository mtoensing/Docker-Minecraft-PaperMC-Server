FROM eclipse-temurin:21-jre

ARG DOWNLOAD_URL

# download paperclip
ADD "${DOWNLOAD_URL}" /opt/minecraft/paperspigot.jar

# add rcon-cli
COPY --from=docker.io/itzg/rcon-cli:latest /rcon-cli /usr/local/bin/rcon-cli

# install dependencies
RUN apt update && apt install -y webp && rm -rf /var/lib/apt/lists/*

# Create minecraft user with fixed UID/GID
RUN groupadd -g 9001 minecraft && \
    useradd -u 9001 -g minecraft -d /home/minecraft -m -s /bin/bash minecraft

# Expose minecraft port
EXPOSE 25565/tcp 25565/udp

# define environment variables
ENV JAVAFLAGS="-Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true"
ENV PAPERMC_FLAGS="--nojline"

# ENV MEMORYSIZE="1G"
# Memory Management Notes:
# - Use container runtime memory limits (--memory flag)
# - Java will automatically detect container memory with -XX:+UseContainerSupport
# Recommended reading: https://www.ibm.com/docs/en/sdk-java-technology/8?topic=options-xx-usecontainersupport

# Set up volumes and permissions
RUN mkdir -p /data && \
    chown -R minecraft:minecraft /opt/minecraft

VOLUME /data
WORKDIR /data

# Set the user to run the server with explicit UID:GID
USER 9001:9001

# Use environment variables to build the startup command
# This allows for configurable JAVAFLAGS and PAPERMC_FLAGS
ENTRYPOINT ["sh", "-c", "java ${JAVAFLAGS} ${MEMORYSIZE:+-Xms$MEMORYSIZE -Xmx$MEMORYSIZE} -jar /opt/minecraft/paperspigot.jar ${PAPERMC_FLAGS} nogui"]
