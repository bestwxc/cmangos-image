#!/bin/bash

# $1 version like 1.0.0
# $2 classic or tbc or wotlk, default tbc

curdir=$(cd `dirname $0`;pwd)
cd $curdir

version=$1
if [ -z "$version" ]
then
    echo "please pass the version. eg: sh build.sh ver [no|classic|tbc|wotlk]"
    exit -1
fi

target=without-maps
case $2 in
	"classic")
		type=classic
		target=with-classic-maps;;
	"tbc")
		type=tbc
		target=with-tbc-maps;;
	"wotlk")
		type=wotlk
		target=with-wotlk-maps;;
	*)
		type=no
		target=without-maps;;
esac
		

echo "cur dir: $curdir"
echo "type: $type"
echo "target: $target"
echo "version: $1"

sudo rm -rf data
sudo mkdir -p data

\sudo tar -xf $type-maps.tgz -C data

sudo docker build . --target=cmangos-$target -t wxc252/base4cmangos:$version-$target

sudo rm -rf data


sudo docker push wxc252/base4cmangos:$version-$target


