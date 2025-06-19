#!/bin/bash
set -ex

BUILD_NAME=${BUILD_NAME:-buildkit}
BUILD_VERSION=${BUILD_VERSION:-v0.16.0}

BUILD_SOCKS5=${BUILD_SOCKS5}

rm -rf ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION}
if [ ! -d ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION} ]; then
  if [ -n "${BUILD_SOCKS5}" ]; then
    git config --global http.proxy ${BUILD_SOCKS5}
  fi
  git clone --recurse-submodules -b ${BUILD_VERSION} https://github.com/moby/buildkit ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION}
fi

apk add --no-cache file bash clang lld musl-dev pkgconfig git make

cd ${BUILD_ROOT}/.tmp/${BUILD_NAME}-${BUILD_VERSION}

GIT_REVISION=$(git rev-parse --short HEAD)
GIT_PKG="github.com/moby/buildkit"

BUILD_LDFLAGS="-X ${GIT_PKG}/version.Version=${BUILD_VERSION} -X ${GIT_PKG}/version.Revision=${GIT_REVISION} -X ${GIT_PKG}/version.Package=${GIT_PKG}"

export GOFLAGS="-mod=vendor"
export CGO_ENABLED=0
export GOGCFLAGS=${BUILDKIT_DEBUG:+"all=-N -l"}
BUILDKITD_TAGS=${BUILDKITD_TAGS:-v0.16.0}

export TARGETPLATFORM="linux/amd64"
xx-go build -ldflags "-s -w ${BUILD_LDFLAGS}" -o ${BUILD_ROOT}/.dist/amd64/buildctl ./cmd/buildctl
xx-verify --static ${BUILD_ROOT}/.dist/amd64/buildctl
xx-go build -gcflags="${GOGCFLAGS}" -ldflags "-s -w ${BUILD_LDFLAGS} -extldflags '-static'" -tags "osusergo netgo static_build seccomp" -o ${BUILD_ROOT}/.dist/amd64/buildkitd ./cmd/buildkitd
xx-verify --static ${BUILD_ROOT}/.dist/amd64/buildkitd

export TARGETPLATFORM="linux/arm64"
xx-go build -ldflags "-s -w ${BUILD_LDFLAGS}" -o ${BUILD_ROOT}/.dist/arm64/buildctl ./cmd/buildctl
xx-verify --static ${BUILD_ROOT}/.dist/arm64/buildctl
xx-go build -gcflags="${GOGCFLAGS}" -ldflags "-s -w ${BUILD_LDFLAGS} -extldflags '-static'" -tags "osusergo netgo static_build seccomp" -o ${BUILD_ROOT}/.dist/arm64/buildkitd ./cmd/buildkitd
xx-verify --static ${BUILD_ROOT}/.dist/arm64/buildkitd
