.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

user = $(shell whoami)
ifeq ($(user),root)
$(error  "do not run as root! run 'gpasswd -a USER docker' on the user of your choice")
endif

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make jessie       - make a local-jessie docker base-image

jessie: mkimage.sh local-jessie.sh local-jessie

rmjessie:
	docker rmi `cat jessie`

local-jessie: 
	sudo bash local-jessie.sh
	docker images -q local-jessie>local-jessie

local-jessie.sh: 
	curl https://raw.githubusercontent.com/tianon/docker-brew-debian/bd71f2dfe1569968f341b9d195f8249c8f765283/jessie/build-command.txt|grep '^mkimage.sh'|sed 's^/\.\//'>local-jessie.sh
	chmod +x local-jessie.sh

mkimage.sh:
	wget https://raw.githubusercontent.com/docker/docker/master/contrib/mkimage.sh
	chmod +x mkimage.sh
