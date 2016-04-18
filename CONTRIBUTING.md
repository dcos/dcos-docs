# Contributing to the DC/OS Documentation

If you want to contribute some documentation, please do the following:

1. Create a [new issue](https://github.com/dcos/dcos-docs/issues) in this repo (`dcos-docs`) and label it with the type of doc you're writing. An example of this would be [tutorial](https://github.com/dcos/dcos-docs/labels/tutorial).
1. [Fork](https://help.github.com/articles/fork-a-repo/) this repo, `dcos-docs` (you only have to do this once).
1. Create a new directory in the appropriate location of the correctly versioned release. For example, if it's a tutorial, create a new directory `foo/` in the `tutorials/` directory.
1. For some types of content, there are provided templates. Copy the appropriate template for your content. For example, if it's a tutorial you can copy [templates/tutorial.md](templates/tutorial.md) into `foo/` and rename it to `README.md`.
1. Adapt the sections in your new `foo/README.md` to the specifics of your content.
1. If you have any screen shots, you can store them in `foo/img/`; also please make sure that all assets (such as a Marathon app spec JSON docs or a Dockerfile you might be using in your documentation) are actually included in the `foo/` directory.
1. When you're done, create a [pull request](https://help.github.com/articles/using-pull-requests/) to the original repo, `dcos-docs`.
1. For all contributions that include hands-on instructions, such as found in `usage/` or `administration/`, the community managers will test-drive and validate before merging. We might come back to you asking you to fix stuff. All communication strictly via your pull request on GitHub.  

Note that if you're unsure about what exactly should go into the tutorial, you can always check out [spark/](/1.7/usage/tutorials/spark/) for reference.
