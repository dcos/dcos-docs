# DC/OS Documentation
Documentation for the Datacenter Operating System (DC/OS)

These documents are used as source to generate <dcos.io>.

**Prior to official release of DC/OS, the contents of this repo are under NDA. See [License and Authors](#license-and-authors) for more details.**

[![Build Status](https://travis-ci.com/dcos/dcos-docs.svg?token=yAREgxuvuzZLg282ZE3m&branch=master)](https://travis-ci.com/dcos/dcos-docs)

## Versions

- [1.7](1.7) (latest)

## Formatting

Markdown in this repository is formatted for rendering with [Jekyll](https://jekyllrb.com/).

- Links should include the full path relative to the root of dcos.io to allow easy search/replace. These links will not work in the github code browser.
- All page links will be directories instead of files.
- Index pages should reside next to any child directory they parent (rather than using Github's README.md indexing)
- Page tables of contents will be automatically generated based on top-level headers
- Directory tables of contents will be automatically generated based on post_titles and post_excerpts

## Contributing

Contribute to the docs using one of the following options:

* Create a Github issue with a suggestion for a tutorial (for example: I'd like to see a tutorial on Apache Kafka)
* Update or write a new doc yourself following the [Contributing Guidelines](CONTRIBUTING.md)

## License and Authors

Copyright:: 2016 Mesosphere, Inc.

The contents of this repository are solely licensed under the terms described in the [LICENSE file](./LICENSE) included in this repository.

Authors are listed in [AUTHORS.md file](./AUTHORS.md).
