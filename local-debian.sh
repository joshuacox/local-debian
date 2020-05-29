#!/usr/bin/env bash
set -e

localDebian="$(basename "$0")"

optTemp=$(getopt -o 'r::h' --long 'release::,help' --name "$localDebian" -- "$@")
eval set -- "$optTemp"
unset optTemp

release=jessie
help=0
compression="auto"
while true; do
	case "$1" in
        -r|--release)
            case "$2" in
                "") release='jessie' ; shift 2 ;;
                *) release=$2 ; shift 2 ;;
            esac ;;
		-h|--help) usage ;;
		--) shift ; break ;;
	esac
done

temp=$(mktemp -d)
OUTPUT_SEMAPHORE=`pwd`/local-$release
apt-get install -yqq debootstrap
chmod 777 "$temp"
sudo /usr/sbin/debootstrap --variant=minbase --include=apt-utils,less,vim,locales,libterm-readline-gnu-perl $release "$temp" http://http.us.debian.org/debian/ 
echo "deb http://security.debian.org/ $release/updates main" > "$temp/etc/apt/sources.list.d/security.list"
echo "deb http://ftp.us.debian.org/debian/ $release-updates main" > "$temp/etc/apt/sources.list.d/update.list"
echo "Upgrading"
chroot "$temp" apt-get update
chroot "$temp" apt-get -y dist-upgrade
# Make all servers America/New_York
echo "America/New_York" > "$temp/etc/timezone"
chroot "$temp" /usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata
chroot "$temp" rm -Rf /var/lib/apt/lists/
echo "Importing into docker"
cd "$temp" && tar -c . | docker import - local-$release
cd /tmp
echo "Removing temp directory"
date -I &>"$OUTPUT_SEMAPHORE"
du -sh "$temp" &>>"$OUTPUT_SEMAPHORE"
rm -rf "$temp"
