########################################################
############## We use a java base image ################
########################################################
FROM eclipse-temurin:21-jre AS build
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y curl jq && \
    # Clean up the apt cache to reduce image size
    rm -rf /var/lib/apt/lists/*

LABEL Marc Tönsing <marc@marc.tv>

ARG version=1.20.4

########################################################
############## Download Paper with API #################
########################################################
WORKDIR /opt/minecraft
COPY ./getpaperserver.sh /
RUN chmod +x /getpaperserver.sh
RUN /getpaperserver.sh ${version}

########################################################
############## Running environment #####################
########################################################
FROM eclipse-temurin:21-jre AS runtime
ARG TARGETARCH
# Install gosu
RUN set -eux; \
 apt-get update; \
 apt-get install -y gosu; \
 rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
 gosu nobody true

# Install webp (e.g. for Dynmap) Might not be available on ARM (RPI)
RUN apt-get update && apt-get install -y webp

# Working directory
WORKDIR /data

# Obtain runable jar from build stage
COPY --from=build /opt/minecraft/paperclip.jar /opt/minecraft/paperspigot.jar

# Volumes for the external data (Server, World, Config...)
VOLUME "/data"

# Expose minecraft port
EXPOSE 25565/tcp
EXPOSE 25565/udp

# Set memory size
ARG memory_size=1G
ENV MEMORYSIZE=$memory_size

# Set Java Flags
ARG java_flags="-Dlog4j2.formatMsgNoLookups=true -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true"
ENV JAVAFLAGS=$java_flags

# Set PaperMC Flags
ARG papermc_flags="--nojline"
ENV PAPERMC_FLAGS=$papermc_flags

WORKDIR /data

COPY /docker-entrypoint.sh /opt/minecraft
RUN chmod +x /opt/minecraft/docker-entrypoint.sh

# Entrypoint
ENTRYPOINT ["/opt/minecraft/docker-entrypoint.sh"]
