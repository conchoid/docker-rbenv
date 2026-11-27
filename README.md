# Docker Images for rbenv

This repository contains Dockerfiles to install [rbenv/rbenv](https://github.com/rbenv/rbenv) within docker containers. Pre-build images are available at [Docker Hub](https://hub.docker.com/r/conchoid/docker-rbenv/).

## Build a multi-architecture OCI image

`4.0-trixie/Dockerfile` targets both `linux/amd64` and `linux/arm64`. It uses the official `ruby` base image, which is multi-architecture, and builds rbenv, ruby-build and Ruby from source, so the same file works for both platforms.

```sh
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --output type=oci,dest=rbenv-oci.tar,name=conchoid/docker-rbenv:v1.3.2-3-4.0.10-trixie \
  -f 4.0-trixie/Dockerfile 4.0-trixie
```

The result is an OCI image archive containing a multi-platform index. To push it to a registry instead, replace `--output` with `--push` and use `-t conchoid/docker-rbenv:v1.3.2-3-4.0.10-trixie`.

