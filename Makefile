.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make jessie       - make a local-jessie docker base-image
wrapper: clean mkimage.sh image-wrapper.sh image-wrapper

update: rmjessie jessie

image-wrapper:
	sudo bash image-wrapper.sh
	echo 1>image-wrapper

# Not to be used for now
image-wrapper.sh:
	echo '#!/bin/bash'> image-wrapper.sh
	curl https://raw.githubusercontent.com/tianon/docker-brew-debian/bd71f2dfe1569968f341b9d195f8249c8f765283/jessie/build-command.txt |grep '^mkimage.sh'|sed 's/^/\.\//'|sed 's/-d/--tag=image-wrapper\ -d/'>>local-jessie.sh
	chmod +x image-wrapper.sh

mkimage.sh:
	wget https://raw.githubusercontent.com/docker/docker/master/contrib/mkimage.sh
	chmod +x mkimage.sh

clean:
	-rm *IID
	-rm mkimage.sh

deps:
	sudo apt-get install debootstrap
	date -I>deps

# Wheezy
wheezy: mkimage.sh local-wheezyIID

rmwheezy:
	-@docker rmi `cat local-wheezyIID`
	-@rm local-wheezyIID

local-wheezyIID:
	sudo bash local-debian.sh --release=wheezy
	docker images -q local-wheezy>local-wheezyIID
	echo 'local-wheezy'>>local-wheezyIID

# Jessie
jessie: mkimage.sh local-jessieIID

rmjessie:
	-@docker rmi `cat local-jessieIID`
	-@rm local-jessieIID

local-jessieIID:
	sudo bash local-debian.sh --release=jessie
	docker images -q local-jessie>local-jessieIID
	echo 'local-jessie'>>local-jessieIID

# Stretch
stretch: mkimage.sh local-stretchIID

rmstretch:
	-@docker rmi `cat local-stretchIID`
	-@rm local-stretchIID

local-stretchIID:
	sudo bash local-debian.sh --release=stretch
	docker images -q local-stretch>local-stretchIID
	echo 'local-stretch'>>local-stretchIID

# Xenial
xenial: mkimage.sh local-xenialIID

rmxenial:
	-@docker rmi `cat local-xenialIID`
	-@rm local-xenialIID

local-xenialIID:
	sudo bash local-debian.sh --release=xenial
	docker images -q local-xenial>local-xenialIID
	echo 'local-xenial'>>local-xenialIID

