Introduction
---

We have put together a Docker image that makes it easy to build and render  DC/OS documentation site locally. The commands below need to be executed from within `dcos-docs` directory.

1. Build the `dcos-docs` container
```bash
$ docker build --no-cache -t dcos-docs scripts/
```

2. Verify that the image was successfully built
```bash
$ docker images | grep dcos-image
```

3. Start the container
```bash
$ docker run -it -p 3000:3000 -p 3001:3001 -v $(pwd):/dcos-docs dcos-docs
```

This command is going to take a while because we need to fetch the contents of main DC/OS web site from GitHub as well as install all necessary dependencies for rendering the website.

4. Wait until the web server within the container comes up. You should see an output similar to the one below in the console
```
> dcos-website@1.0.0 start /home/docsuser/dcos-website
> node index.js

Transformers.markdown is deprecated, you must replace the :markdown jade filter, with :marked and install jstransformer-marked before you update to jade@2.0.0.
[BS] Access URLs:
 -----------------------------------
       Local: http://localhost:3000
    External: http://172.17.0.2:3000
 -----------------------------------
          UI: http://localhost:3001
 UI External: http://172.17.0.2:3001
 -----------------------------------
[BS] Serving files from: ./build
```

The site should be available at http://localhost:3000 and the Browsersync should be at http://localhost:3001. At this point changes you made to the local copy of dcos-docs should be visible in the documentation section of the website.



To stop the web server (and the container) just hit Ctrl-C.
