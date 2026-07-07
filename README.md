# buildkit

编译buildkit组件

## build

[buildkit](https://github.com/moby/buildkit)

```bash
# build cross
docker pull registry.cn-qingdao.aliyuncs.com/wod/golang:1.26-alpine && \
docker run -it --rm \
  -v $PWD/:/go/src/github.com/open-beagle/ \
  -w /go/src/github.com/open-beagle/ansible-docker-buildkit \
  -e BUILD_VERSION=v0.31.1 \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.26-alpine \
  ash src/build.sh
```

## deploy

```bash
docker run -it --rm \
  -v /opt/bin:/opt/bin \
  registry.cn-qingdao.aliyuncs.com/wod/buildkit:v0.31.1 \
  ash -c 'cp /usr/bin/buildctl /opt/bin/buildctl-linux-v0.31.1 && \
    rm -rf /opt/bin/buildctl && \
    ln -s /opt/bin/buildctl-linux-v0.31.1 /opt/bin/buildctl && \
    chmod +x /opt/bin/buildctl-linux-v0.31.1 && \
    cp /usr/bin/buildkitd /opt/bin/buildkitd-linux-v0.31.1 && \
    rm -rf /opt/bin/buildkitd && \
    ln -s /opt/bin/buildkitd-linux-v0.31.1 /opt/bin/buildkitd && \
    chmod +x /opt/bin/buildkitd-linux-v0.31.1'
```
