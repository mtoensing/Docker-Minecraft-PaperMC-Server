########################################################
############## We use a java base image ################
########################################################
FROM openjdk:16-alpine AS build
RUN apk --no-cache add curl

MAINTAINER Stephen Farnsworth <ilektron@ilektronx.com>

ARG version=1.17.1

########################################################
############## Download Paper with API #################
########################################################
WORKDIR /opt/minecraft
COPY ./getpaperserver.sh /
RUN chmod +x /getpaperserver.sh
RUN /getpaperserver.sh ${version}

# Run paperclip and obtain patched jar
RUN /opt/openjdk-16/bin/java -Dpaperclip.patchonly=true -jar /opt/minecraft/paperclip.jar; exit 0

# Copy built jar
RUN mv /opt/minecraft/cache/patched*.jar paperspigot.jar

########################################################
############## Running environment #####################
########################################################
FROM openjdk:16-alpine AS runtime

# Working directory
WORKDIR /data

# Obtain runable jar from build stage
COPY --from=build /opt/minecraft/paperspigot.jar /opt/minecraft/paperspigot.jar

# Install and run rcon
ARG RCON_CLI_VER=1.4.8
ADD https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VER}/rcon-cli_${RCON_CLI_VER}_linux_amd64.tar.gz /tmp/rcon-cli.tgz
RUN tar -x -C /usr/local/bin -f /tmp/rcon-cli.tgz rcon-cli && \
  rm /tmp/rcon-cli.tgz

# Volumes for the external data (Server, World, Config...)
VOLUME "/data"

# Expose minecraft port
EXPOSE 25565/tcp
EXPOSE 25565/udp

# Set memory size
ARG memory_size=3G
ENV MEMORYSIZE=$memory_size

# Set Java Flags
ARG java_flags="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true"
ENV JAVAFLAGS=$java_flags

WORKDIR /data

COPY /docker-entrypoint.sh /opt/minecraft
RUN chmod +x /opt/minecraft/docker-entrypoint.sh

# Install gosu
RUN set -eux; \
	apk update; \
	apk add --no-cache su-exec;

# Entrypoint
ENTRYPOINT ["/opt/minecraft/docker-entrypoint.sh"]
