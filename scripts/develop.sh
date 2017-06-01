#!/bin/bash

if [ ! -d tmp/website ]; then
  mkdir tmp
  git clone https://github.com/dcos/dcos-website tmp/website
fi

if ! docker images | grep docs-runner; then
  docker build -t docs-runner .
fi

cd tmp/website
git pull origin develop
docker run --privileged -it -p 3000:3000 -p 3001:3001 -v $PWD:/website -v $PWD/../..:/dcos-docs \
  docs-runner:latest /dcos-docs/scripts/run-server.sh
