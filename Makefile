help:
	@echo "Custom Makefile by Levi Olson:"; \
	echo "version 1.0"; \
	echo ""; \
	echo "\thelp\tPrints this message"; \
	echo ""; \
	echo "\tstart\tdocker-compose up --build"; \
	echo "\t\t(starts the minecraft server)"; \
	echo ""; \
	echo "\tstop\tdocker-compose stop --rmi all --remove-orphans"; \
	echo "\t\t(stops and cleans up images, but keeps data)"; \
	echo ""; \
	echo "\tattach\tdocker attach minecraft"; \
	echo "\t\t(attaches to minecraft paper jar for issuing commands)";

start:
	@echo "Starting Minecraft Server..."; \
	docker-compose up --build;

stop:
	@echo "Stopping Minecraft Server and cleaning up..."; \
	docker-compose down --rmi all --remove-orphans;

attach:
	@echo "Attaching to Minecraft..."; \
	echo "Ctrl-C stops minecraft and exits"; \
	echo "Ctrl-P Ctrl-Q only exits"; \
	echo ""; \
	echo "Type "help" for help."; \
	docker attach minecraft;