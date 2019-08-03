################################
### We use a java base image ###
################################
FROM openjdk:11 AS build

MAINTAINER Marc Tönsing <marc@marc.tv>

ARG paperspigot_ci_url=https://papermc.io/api/v1/paper/1.14.4/latest/download
ENV PAPERSPIGOT_CI_URL=$paperspigot_ci_url

WORKDIR /opt/minecraft

##########################
### Download paperclip ###
##########################
ADD ${PAPERSPIGOT_CI_URL} paperclip.jar

############
### User ###
############
RUN useradd -ms /bin/bash minecraft && \
    chown minecraft /opt/minecraft -R

USER minecraft


############################################
### Run paperclip and obtain patched jar ###
############################################
RUN /usr/local/openjdk-11/bin/java -jar /opt/minecraft/paperclip.jar; exit 0

# Copy built jar
RUN mv /opt/minecraft/cache/patched*.jar paperspigot.jar

###########################
### Running environment ###
###########################
FROM openjdk:11 AS runtime

#########################
### Working directory ###
#########################
WORKDIR /data

###########################################
### Obtain runable jar from build stage ###
###########################################
COPY --from=build /opt/minecraft/paperspigot.jar /opt/minecraft/paperspigot.jar

############################
### Obtain server config ###
###########################
ADD server.properties /opt/minecraft/server.properties

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
ENTRYPOINT /usr/local/openjdk-11/bin/java -jar -Xms$MEMORYSIZE -Xmx$MEMORYSIZE -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true /opt/minecraft/paperspigot.jar
