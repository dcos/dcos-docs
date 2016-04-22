# DC/OS Documentation
Documentation for the Datacenter Operating System (DC/OS)

These documents are used as source to generate [dev.dcos.io/docs](https://dev.dcos.io/docs) (staging) and [dcos.io/docs](https://dcos.io/docs) (production). They are submoduled into [dcos-website](https://github.com/dcos/dcos-website) for deployment.

[![Build Status](https://travis-ci.com/dcos/dcos-docs.svg?token=yAREgxuvuzZLg282ZE3m&branch=master)](https://travis-ci.com/dcos/dcos-docs)

**Issue tracking is moving to the [DCOS JIRA](https://dcosjira.atlassian.net/) ([dcos-docs component](https://dcosjira.atlassian.net/issues/?jql=project%20%3D%20DCOS%20AND%20component%20%3D%20dcos-docs)).
Issues on Github will be disabled soon.**

## Versions

- [1.7](1.7) (latest)

## Formatting

Markdown in this repository is formatted for rendering with [Jekyll](https://jekyllrb.com/).

- Links should include the full path relative to the root of dcos.io to allow easy search/replace. These links will not work in the github code browser.
- All page links will be directories instead of files.
- Index pages should reside next to any child directory they parent (rather than using Github's README.md indexing).
- Page tables of contents will be automatically generated based on top-level headers.
- Directory tables of contents will be automatically generated based on post_titles and post_excerpts.

## Contributing

Contribute to the docs using one of the following options:

* Create [DCOS JIRA](https://dcosjira.atlassian.net/) ([dcos-docs component](https://dcosjira.atlassian.net/issues/?jql=project%20%3D%20DCOS%20AND%20component%20%3D%20dcos-docs)) with a suggestion for a tutorial (for example: I'd like to see a tutorial on Apache Kafka).
* Update or write a new doc yourself following the [Contributing Guidelines](CONTRIBUTING.md).

## License and Authors

Copyright 2016 Mesosphere, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this repository except in compliance with the License.

The contents of this repository are solely licensed under the terms described in the [LICENSE file](./LICENSE) included in this repository.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Authors are listed in [AUTHORS.md file](./AUTHORS.md).
