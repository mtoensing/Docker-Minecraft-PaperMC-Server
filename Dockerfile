########################################################
############## We use a java base image ################
########################################################
FROM openjdk:11 AS build

MAINTAINER Marc Tönsing <marc@marc.tv>

ARG paperspigot_ci_url=https://papermc.io/api/v1/paper/1.15.1/latest/download
ENV PAPERSPIGOT_CI_URL=$paperspigot_ci_url

WORKDIR /opt/minecraft

# Download paperclip
ADD ${PAPERSPIGOT_CI_URL} paperclip.jar

# User
RUN useradd -ms /bin/bash minecraft && \
    chown minecraft /opt/minecraft -R

USER minecraft

# Run paperclip and obtain patched jar
RUN /usr/local/openjdk-11/bin/java -jar /opt/minecraft/paperclip.jar; exit 0

# Copy built jar
RUN mv /opt/minecraft/cache/patched*.jar paperspigot.jar

########################################################
############## Running environment #####################
########################################################
FROM openjdk:11 AS runtime

# Working directory
WORKDIR /data

# Obtain runable jar from build stage
COPY --from=build /opt/minecraft/paperspigot.jar /opt/minecraft/paperspigot.jar

# Install and run rcon
ARG RCON_CLI_VER=1.4.6
ADD https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VER}/rcon-cli_${RCON_CLI_VER}_linux_amd64.tar.gz /tmp/rcon-cli.tgz
RUN tar -x -C /usr/local/bin -f /tmp/rcon-cli.tgz rcon-cli && \
  rm /tmp/rcon-cli.tgz

# Obtain server config
ADD server.properties /opt/minecraft/server.properties

# Volumes for the external data (Server, World, Config...)
VOLUME "/data"

# Expose minecraft port
EXPOSE 25565/tcp
EXPOSE 25565/udp

# Set Memory Size
ARG memory_size=3G
ENV MEMORYSIZE=$memory_size

WORKDIR /data

# Entrypoint with java optimisations
ENTRYPOINT /usr/local/openjdk-11/bin/java -jar -Xms$MEMORYSIZE -Xmx$MEMORYSIZE -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true /opt/minecraft/paperspigot.jar
