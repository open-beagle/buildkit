# buildkit

编译buildkit组件

## build

[buildkit](https://github.com/moby/buildkit)

```bash
docker pull registry.cn-qingdao.aliyuncs.com/wod/golang:1.22-alpine && \
docker run -it --rm \
  -v $PWD/:/go/src/github.com/open-beagle/buildkit \
  -w /go/src/github.com/open-beagle/buildkit \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.22-alpine \
  bash src/build.sh
```

## deploy

```bash
docker run -it --rm \
  -v /opt/bin:/opt/bin \
  registry.cn-qingdao.aliyuncs.com/wod/buildkit:v0.16.0 \
  cp /usr/bin/buildctl /opt/bin/buildctl-linux-v0.16.0 && \
  ln -s /opt/bin/buildctl-linux-v0.16.0 /opt/bin/buildctl && \
  chmod +x /opt/bin/buildctl-linux-v0.16.0 && \
  cp /usr/bin/buildkitd /opt/bin/buildkitd-linux-v0.16.0 && \
  ln -s /opt/bin/buildkitd-linux-v0.16.0 /opt/bin/buildkitd && \
  chmod +x /opt/bin/buildkitd-linux-v0.16.0 
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="buildkit" \
  -e PLUGIN_MOUNT="./.git,./.tmp" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="buildkit" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
