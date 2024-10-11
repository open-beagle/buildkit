#!/bin/bash
set -ex

BUILD_ROOT="$(pwd)"
BUILD_NAME=${BUILD_NAME:-buildkit}
BUILD_VERSION=${BUILD_VERSION:-v0.16.0}

BUILD_SOCKS5=${BUILD_SOCKS5:-"socks5://www.ali.wodcloud.com:1283"}

if [ ! -d ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION} ]; then
  git config --global http.proxy ${BUILD_SOCKS5}
  git clone --recurse-submodules -b ${BUILD_VERSION} https://github.com/moby/buildkit ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION}
fi

cd ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION}

GIT_REVISION=$(git rev-parse --short HEAD)
GIT_PKG="github.com/moby/buildkit"

BUILD_LDFLAGS="-X ${GIT_PKG}/version.Version=${BUILD_VERSION} -X ${GIT_PKG}/version.Revision=${GIT_REVISION} -X ${GIT_PKG}/version.Package=${GIT_PKG}"

export GOFLAGS="-mod=vendor"
export CGO_ENABLED=0
export GOGCFLAGS=${BUILDKIT_DEBUG:+"all=-N -l"}
BUILDKITD_TAGS=${BUILDKITD_TAGS:-v0.16.0}

export GOARCH=loong64
go build -ldflags "-s -w ${BUILD_LDFLAGS}" -o ${BUILD_ROOT}/.dist/loong64/buildctl ./cmd/buildctl
go build -gcflags="${GOGCFLAGS}" -ldflags "-s -w ${BUILD_LDFLAGS} -extldflags '-static'" -tags "osusergo netgo static_build seccomp" -o ${BUILD_ROOT}/.dist/loong64/buildkitd ./cmd/buildkitd
