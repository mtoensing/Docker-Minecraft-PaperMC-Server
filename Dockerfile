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

RUN apk --update add screen

###################
### Environment ###
###################
ENV JAVA_ARGS "-Xmx3G"
ENV SPIGOT_ARGS ""
ENV PAPERSPIGOT_ARGS ""

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
ADD start.sh /opt/minecraft/server/start.sh

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
ENTRYPOINT sh /opt/minecraft/server/start.sh
