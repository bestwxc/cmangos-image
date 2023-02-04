#!/bin/bash

# $1 version like 1.0.0
# $2 classic or tbc or wotlk, default tbc
# $3 target: cmangos-db, cmangos-with-maps, cmangos-without-maps(default)

image_name_prefix=wxc252

curdir=$(cd `dirname $0`;pwd)
cd $curdir

version=$1
if [ -z "$version" ]
then
    echo "please pass the version. eg: sh build.sh ver [classic|tbc|wotlk] [db|simple|full]"
    exit -1
fi

case $2 in
	"classic")
		type=classic;;
	"tbc")
		type=tbc;;
	"wotlk")
		type=wotlk;;
	*)
		type=tbc;;
esac


case $3 in
	"db")
		target=cmangos-db;;
	"simple")
		target=cmangos-without-maps;;
	"full")
		target=cmangos-with-maps;;
	"cmangos-with-maps")
		target=cmangos-with-maps;;
	"cmangos-without-maps")
		target=cmangos-without-maps;;
	"cmangos-db")
		target=cmangos-db;;
	*)
		target="cmangos-without-maps";;
esac


echo "cur dir: $curdir"
echo "type: $type"
echo "target: $target"
echo "version: $version"


image_name=$image_name_prefix/$target-$type:$version

sudo docker build . --target=$target -t $image_name --build-arg WOW_VER=$type

# uncomment this line if you want push image to the reps.
sudo docker push $image_name


