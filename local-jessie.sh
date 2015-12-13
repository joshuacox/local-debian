#!/bin/bash

temp=$(mktemp -d)
jessie=`pwd`/local-jessie
apt-get install -yq debootstrap
debootstrap --variant=minbase --include=apt-utils,less,vim,locales,libterm-readline-gnu-perl jessie "$temp" http://http.us.debian.org/debian/ 
echo "deb http://security.debian.org/ jessie/updates main" > "$temp/etc/apt/sources.list.d/security.list"
echo "deb http://ftp.us.debian.org/debian/ jessie-updates main" > "$temp/etc/apt/sources.list.d/update.list"
echo "Upgrading"
chroot "$temp" apt-get update
chroot "$temp" apt-get -y dist-upgrade
# Make all servers America/New_York
echo "America/New_York" > "$temp/etc/timezone"
chroot "$temp" /usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata
chroot "$temp" rm -Rf /var/lib/apt/lists/
echo "Importing into docker"
cd "$temp" && tar -c . | docker import - local-jessie 
cd
echo "Removing temp directory"
date -I &>"$jessie"
du -sh "$temp" &>>"$jessie"
rm -rf "$temp"
./mkimage.sh --tag=image-wrapper -d . debootstrap --variant=minbase --components=main --include=inetutils-ping,iproute2 --force-check-gpg jessie http://httpredir.debian.org/debian
