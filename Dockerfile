FROM node:7.1.0-slim

RUN apt-get update && apt-get install -y \
    git \
    python \
    build-essential \
    rsync \
    inotify-tools \
 && rm -rf /var/lib/apt/lists/*
