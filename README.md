# DC/OS Documentation [![Build Status](https://jenkins.mesosphere.com/service/jenkins/buildStatus/icon?job=public-dcos-docs-master)](https://jenkins.mesosphere.com/service/jenkins/job/public-dcos-docs-master)
Documentation for the Datacenter Operating System (DC/OS)

These documents are used as source to generate [dev.dcos.io/docs](https://dev.dcos.io/docs) (staging) and [dcos.io/docs](/docs) (production). They are submoduled into [dcos-website](https://github.com/dcos/dcos-website) for deployment.


**Issue tracking is moving to the [DCOS JIRA](https://dcosjira.atlassian.net/) ([docs component](https://dcosjira.atlassian.net/issues/?jql=project%20%3D%20DCOS%20AND%20component%20%3D%20docs)).
Issues on Github will be disabled soon.**

# Contributing

If this is your first contribution to an open source software (OSS) project, congratulations! Contributing to the documentation is a great way to get started. By following these instructions you can learn more about DC/OS, and contribute back to an OSS project right away. No expertise necessary!

This page provides instructions on how to contribute to the DC/OS documentation. The process ensures that work is not duplicated, and that your contributions are merged and approved by the admins. To get started you need a [GitHub account](https://github.com/join?source=header-home) and an account on the [DC/OS JIRA](https://dcosjira.atlassian.net/admin/users/sign-up).

- [Making your contribution](#making)
- [Styling and formatting your contribution](#styling)
- [Building and testing your content locally](#test-local)

## <a name="making"></a>Making your contribution

1. Search [JIRA](https://dcosjira.atlassian.net/issues/?filter=10201) to review the currently open issues and make sure that no one is already working on your issue. If you find an open issue that is unassigned that you want to work, you can assign it to yourself! If you don’t see an issue related to yours, [create a new issue](https://dcosjira.atlassian.net/secure/CreateIssue!default.jspa), select documentation as the component, and assign it to yourself.

  <img src="/images/2017-01-11_JIRA_screen_cap.png"/>

1. If this is your first contribution [Fork](https://help.github.com/articles/fork-a-repo/) the [dcos-docs](https://github.com/dcos/dcos-docs) repo. (Once you’ve forked the repo, that fork stays associated with your GitHub account. If you try to fork it again GitHub will remind you that you already have a fork.)

1. Create a local repository, or if you already have one make sure it is up to date.

  - If this is your first contribution, go to your terminal, navigate to the directory where you keep your Git projects, and clone your fork of the [dcos-docs](https://github.com/dcos/dcos-docs) repo.


      ```bash
      $ git clone https://github.com/<your-user-name>/dcos-docs
      ```

  - If this isn't your first contribution check out the master branch

        ```bash
        $ git checkout master
        ```

      and update it by following these [instructions](https://help.github.com/articles/syncing-a-fork/).

1. Create a new branch of your local repository using your JIRA number as the name. This way other contributors can find the JIRA issue that descirbes the goal of your contribution.

    ```bash
    $ git checkout -b dcos-nnn
    ```

1. Create your content.

  - In most cases you should be able to create your content within the existing directory structure.
  - If you're not sure how to add formatting, take a look at [dcos.io/docs](dcos.io/docs/) for examples.
  - Be sure you follow the style and formatting guidelines in the [next section](#styling).
  - Don't forget to update your post's metadata if necessary, including the required metadata `post_title` and optional `nav_title` and `menu_order`. Where applicable, add the optional `feature_maturity` label. Description of various feature maturity phases can be found [here](https://dcos.io/docs/1.8/overview/feature-maturity/).

  The metadata should be at the very top of the post's file, and look something like this:

    ```
    ---
    post_title: This is how you update the documentation
    nav_title: Update Docs
    menu_order: 5
    feature_maturity: preview
    ---
    The rest of your document's text will go here, underneath the second set of dashes.
    ```    

  - Don't forget to save your changes

1. When you're happy with your improvements, build a local copy of the website by following these [instructions](#test-local) to make sure that everything looks good, and that nothing is broken.

1. Push your changes into the feature branch of your remote repository on github.com.

  1. First, add your changes (this gets them ready to be included in your commit).

    ```bash
    $ git add .
    ```

  1. Next commit the changes you made to your local branch, and add a useful message so that everyone knows what you've changed.

    ```bash
    $ git commit -m "Addresses issue DCOS-nnn. More useful stuff here"
    ```

  1. Finally push your changes up to your remote branch on GitHub, so that you can open a pull request.

    ```bash
    $ git push origin dcos-nnn
    ```

1. Submit a [pull request](https://help.github.com/articles/using-pull-requests/) against the [dcos-docs](https://github.com/dcos/dcos-docs) repo.

  - Don't forget to add a link to this PR in your [JIRA issue](https://dcosjira.atlassian.net/).
  - Community managers will test drive and validate contributions that include hands-on instructions, and they'll probably ask for improvements or modifications by commenting on your PR. If you agree with their changes make them in your local repo and repeat steps 5-7 above, or feel free to continue the discussion.

## <a name="styling"></a>Styling and formatting your contribution

- Use [GitHub-flavored markdown](https://help.github.com/enterprise/11.10.340/user/articles/github-flavored-markdown/).
- Use relative links.
  - Begin all links at the root `docs` level and include the version number subdirectory. (e.g., `/docs/1.8/administration/sshcluster/`).
- Do not include file extensions in your link or image paths. For example, the directory `/docs/1.8/administration/` contains a file named `user-management.md`. To link to this content on the live site, you would use the following path: `/docs/1.8/administration/user-management/`.
- Each directory must contain an `index.md` file. This acts as the base-level topic for each folder in the site (required).
- The table of contents of each page is automatically generated based on the top-level headers.
  - Directory tables of contents are automatically generated based on `post_title` (or `nav_title`) and `post_excerpt` headers.
- Use active voice whenever possible.
- Use sentence-style capitalization for headings.

In addition to the above technical notes, make sure you read your doc for clarity and accuracy. Pretend you are someone else seeing your instructions for the first time, and try to follow them based only on the information you provided.

## <a name="test-local"></a>Building and testing your content locally

Pick one of the below methods to build your changes, integrated with the rest of dcos.io, on your local machine. This makes sure that your changes don't break the docs or the website. If you're not sure which method you should use to build the website locally, we recommend the automated build, because it has fewer prerequisites and is more reliable. If you find problems with your doc, edit the file. Your local build should update every time you save your changes.


### Automated build
This method builds and launches a Docker container. For more information, see this [PR](https://github.com/dcos/dcos-docs/pull/532).

#### Prerequisite

Latest version of [Docker](https://docs.docker.com/engine/installation/) installed and running.

#### Building

1. Run `sudo make`.

    **Tip:** This can take up to 15 minutes to complete.
1. Visit [localhost](http://localhost:3000)

#### Troubleshooting

If your build fails with an error (e.g. `npm ERR!     /website/npm-debug.log`), try deleting the `/dcos-docs/tmp` directory and re-running the `make` command.

### Manual build

We've implemented the [dcos-docs](https://github.com/dcos/dcos-docs) repo as a [submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) of the [dcos-website](https://github.com/dcos/dcos-website) repo. Fork the parent [dcos-website](https://github.com/dcos/dcos-website) repo and build the site locally. This will allow you to confirm that your content renders correctly and that all of your links work. For each step, follow the instructions for your operating system.

#### Prerequisites

1.  [Ruby](https://www.ruby-lang.org/en/documentation/installation/)

  -  *CentOS*

     ```bash
     $ sudo yum install -y ruby
     ```

  -  *MacOS using [Homebrew](http://brew.sh/)*

      ```bash
      $ brew install ruby
      ```

1.  [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

  -  *CentOS*

      ```bash
      $ sudo yum install git
      ```

  -  *MacOS using [Homebrew](http://brew.sh/)*

      ```bash
      $ brew install git
      ```

1.  Install EPEL repo, [Node](https://docs.npmjs.com/getting-started/installing-node), and NPM.

  -  *CentOS*

      ```bash
      $ sudo yum install -y epel-release && sudo yum install -y nodejs && sudo yum install -y npm && npm update
      ```

  -  *MacOS using [Homebrew](http://brew.sh/)*

      ```bash
      $ brew install -y nodejs
      $ brew install npm
      $ npm update
      ```

1.  nvm 6.3.1

  -  *CentOS*

      ```bash
      $ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash
      $ nvm install 6.3.1 && nvm alias default 6.3.1
      ```

  -  *MacOS*

      ```bash
      $ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash
      $ nvm install 6.3.1 && nvm alias default 6.3.1
      ```

1.  [Gulp](http://gulpjs.com/)

  -  *CentOS*

      ```bash
      $ sudo npm install --global gulp-cli
      ```

  -  *MacOS*

      ```bash
      $ npm install --global gulp-cli
      ```

1. Clone the dcos-website repo.

  ```bash
  $ git clone https://github.com/dcos/dcos-website
  ```

1. Check out the develop branch of `dcos-website`.

  ```bash
  $ git checkout develop
  ```

1. Initialize the `dcos-docs` submodule with the content from the upstream master.

  ```bash
  $ git submodule update --init --recursive
  ```

  Optional: replace the content from the upstream master with the content from your local `dcos-docs` repo. Delete the `dcos-website/dcos-dcos` directory and replace it with a symlink to your local `dcos-docs` repo. For example, if your directory structure is `/projects/dcos-website` and `/projects/dcos-docs`, you can issue these commands from the `dcos-website` directory:

   ```bash
   $ rm -r dcos-docs
   $ ln -s <local-path-to-dcos-docs> dcos-docs
   ```

#### Building

Launch the local web server to view your changes.

  ```bash
  $ npm start
  ```

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
