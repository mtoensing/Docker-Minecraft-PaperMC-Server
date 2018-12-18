#/bin/sh
cd /data
/usr/bin/screen -S minecraft /opt/jdk1.8.0_192/jre/bin/java -jar -Xms800M -Xmx800M -Dcom.mojang.eula.agree=true /opt/minecraft/server/paperspigot.jar
screen -ls

#java -version
#java -jar $JAVA_ARGS -Dcom.mojang.eula.agree=true /opt/minecraft/server/paperspigot.jar $SPIGOT_ARGS $PAPERSPIGOT_ARGS
