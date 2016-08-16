FROM ubuntu

# Add a user.
RUN groupadd admin
RUN useradd -ms /bin/bash -g admin docsuser

# Install system packages and npm modules.
RUN apt-get update
RUN apt-get install -y sudo ruby nodejs nodejs-legacy npm git curl sudo
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash
RUN apt-get install nvm
RUN nvm install 6.3.1 && nvm alias default 6.3.1
ENV source ~/.profile
RUN npm install gulp -g
RUN npm update

# Enable sudo for docsuser.
RUN echo 'docsuser ALL= NOPASSWD: ALL' >> /etc/sudoers

# Add the script for checking out and building the site.
ADD site-local.sh /home/docsuser/site-local.sh
RUN chown docsuser /home/docsuser/site-local.sh
RUN chmod +x /home/docsuser/site-local.sh

# Expose necessary ports.
EXPOSE 3000
EXPOSE 3001

USER docsuser
WORKDIR /home/docsuser

CMD /home/docsuser/site-local.sh
