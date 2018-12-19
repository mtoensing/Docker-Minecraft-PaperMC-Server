################################
### We use a java base image ###
################################
FROM openjdk:8 AS build

MAINTAINER Marc Tönsing <marc@marc.tv>

#################
### Arguments ###
#################
ARG PAPERSPIGOT_CI_URL=https://papermc.io/ci/job/Paper-1.13/lastSuccessfulBuild/artifact/paperclip.jar

##########################
### Download paperclip ###
##########################
ADD ${PAPERSPIGOT_CI_URL} /opt/minecraft/server/paperclip.jar

############################################
### Run paperclip and obtain patched jar ###
############################################
RUN cd /opt/minecraft/server/ \
    && java -jar paperclip.jar; exit 0

RUN cd /opt/minecraft/server/ \
    && mv cache/patched*.jar paperspigot.jar

###########################
### Running environment ###
###########################
FROM anapsix/alpine-java:latest

###########################
### Install screen      ###
###########################
RUN apk --update add screen

#########################
### Working directory ###
#########################
WORKDIR /data

###########################################
### Obtain runable jar from build stage ###
###########################################
COPY --from=build /opt/minecraft/server/paperspigot.jar /opt/minecraft/server/paperspigot.jar

########################
### Obtain starth.sh ###
########################
ADD dockerfiles/start.sh /opt/minecraft/server/start.sh

############################
### Obtain server config ###
###########################
ADD dockerfiles/server.properties /opt/minecraft/server/server.properties

###############
### Volumes ###
###############
VOLUME "/data"

###############
### RCON   ###
###############
ARG RCON_CLI_VER=1.4.0
ARG ARCH=amd64
ADD https://github.com/itzg/rcon-cli/releases/download/${RCON_CLI_VER}/rcon-cli_${RCON_CLI_VER}_linux_${ARCH}.tar.gz /tmp/rcon-cli.tgz
RUN tar -x -C /usr/local/bin -f /tmp/rcon-cli.tgz rcon-cli && \
  rm /tmp/rcon-cli.tgz


#############################
### Expose minecraft port ###
#############################
EXPOSE 25565

######################################
### Entrypoint is the start script ###
######################################
WORKDIR /data
ENTRYPOINT sh /opt/minecraft/server/start.sh
