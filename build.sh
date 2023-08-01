#!/bin/bash
set -e
cd `dirname $0`

ROOT_PATH=$(pwd)
DOCKER_TAG='zhpjy/luoxu'
DOCKER_VERSION=$(date '+%Y%m%d')
BUILD_PATH=$(mktemp -dp .)

https_proxy=http://192.168.2.254:1081
http_proxy=http://192.168.2.254:1081

cd $BUILD_PATH
git clone --depth 1 -b master https://github.com/lilydjwg/luoxu.git .
cat >querytrans/rust-toolchain.toml<<EOF
[toolchain]
channel = "nightly-2023-06-27"
EOF
cp $ROOT_PATH/Dockerfile .

sudo docker build -t $DOCKER_TAG:$DOCKER_VERSION .
