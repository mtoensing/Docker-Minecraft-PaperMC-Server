#/bin/sh
java -version
java -jar $JAVA_ARGS -Dcom.mojang.eula.agree=true /opt/minecraft/server/paperspigot.jar $SPIGOT_ARGS $PAPERSPIGOT_ARGS
