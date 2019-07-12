################################
### We use a java base image ###
################################
FROM openjdk:11 AS build

MAINTAINER Marc Tönsing <marc@marc.tv>

ARG paperspigot_ci_url=https://papermc.io/api/v1/paper/1.14.3/129/download
ENV PAPERSPIGOT_CI_URL=$paperspigot_ci_url

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

#########################
### Working directory ###
#########################
WORKDIR /data

###########################################
### Obtain runable jar from build stage ###
###########################################
COPY --from=build /opt/minecraft/server/paperspigot.jar /opt/minecraft/server/paperspigot.jar

############################
### Obtain server config ###
###########################
ADD server.properties /opt/minecraft/server/server.properties

###############
### Volumes ###
###############
VOLUME "/data"

#############################
### Expose minecraft port ###
#############################
EXPOSE 25565

######################################
### Entrypoint is the start script ###
######################################
ARG memory_size=3G
ENV MEMORYSIZE=$memory_size

WORKDIR /data
ENTRYPOINT java -jar -Xms$MEMORYSIZE -Xmx$MEMORYSIZE -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true /opt/minecraft/server/paperspigot.jar
