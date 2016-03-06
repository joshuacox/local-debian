#!/bin/bash

temp=$(mktemp -d)
DISTRO=$1
OUTPUT_DIR=`pwd`/local-$1
apt-get install -yq debootstrap
debootstrap --variant=minbase --include=apt-utils,less,vim,locales,libterm-readline-gnu-perl $1 "$temp" http://http.us.debian.org/debian/ 
echo "deb http://security.debian.org/ $1/updates main" > "$temp/etc/apt/sources.list.d/security.list"
echo "deb http://ftp.us.debian.org/debian/ $1-updates main" > "$temp/etc/apt/sources.list.d/update.list"
echo "Upgrading"
chroot "$temp" apt-get update
chroot "$temp" apt-get -y dist-upgrade
# Make all servers America/New_York
echo "America/New_York" > "$temp/etc/timezone"
chroot "$temp" /usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata
chroot "$temp" rm -Rf /var/lib/apt/lists/
echo "Importing into docker"
cd "$temp" && tar -c . | docker import - local-$1 
cd
echo "Removing temp directory"
date -I &>"$OUTPUT_DIR"
du -sh "$temp" &>>"$OUTPUT_DIR"
rm -rf "$temp"
