#!/bin/bash

git clone https://github.com/dcos/dcos-website
cd dcos-website
git checkout develop

# Clean up dcos-docs and use the local copy instead.
rm -rf dcos-docs
ln -s /dcos-docs

# Update npm and install dependencies.
sudo npm install npm@latest -g
npm install

# Start the web server.
npm start
