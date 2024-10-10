#!/bin/bash
set -ex

BUILD_NAME=${BUILD_NAME:-buildkit}
BUILD_VERSION=${BUILD_VERSION:-v0.16.0}

BUILD_SOCKS5=${BUILD_SOCKS5:-"socks5://www.ali.wodcloud.com:1283"}

apk add --no-cache file bash clang lld musl-dev pkgconfig git make

if [ ! -d ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION} ]; then
  git config --global http.proxy ${BUILD_SOCKS5}
  git clone --recurse-submodules -b ${BUILD_VERSION} https://github.com/moby/buildkit ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION}
fi

# cd ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION}

# mkdir -p ${BUILD_ROOT}/.dist/amd64
# export GOARCH=amd64
# make binaries
# cp ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION}/build/bin/linux/amd64/crictl ${BUILD_ROOT}/.dist/amd64/crictl

# mkdir -p ${BUILD_ROOT}/.dist/arm64
# export GOARCH=arm64
# make binaries
# cp ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION}/build/bin/linux/arm64/crictl ${BUILD_ROOT}/.dist/arm64/crictl
