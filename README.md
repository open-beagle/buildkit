# buildkit

编译buildkit组件

## build

[buildkit](https://github.com/moby/buildkit)

```bash
# tonistiigi/xx
docker pull tonistiigi/xx:

docker run -it --rm \
  -v $PWD/:/go/src/github.com/open-beagle/buildkit \
  -w /go/src/github.com/open-beagle/buildkit \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.22-alpine \
  bash src/build.sh
```

## deploy

```bash
docker run -it --rm \
  -v /etc/kubernetes/downloads:/etc/kubernetes/downloads \
  registry.cn-qingdao.aliyuncs.com/wod/buildkit:v1.31.1 \
  cp /bin/crictl /etc/kubernetes/downloads/crictl-linux-v1.31.1 && \
mkdir -p /opt/bin && \
ln -s /etc/kubernetes/downloads/crictl-linux-v1.31.1 /opt/bin/crictl && \
chmod +x /etc/kubernetes/downloads/crictl-linux-v1.31.1
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
