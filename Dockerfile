# Yeoman with some generators and prerequisites
FROM google/debian:wheezy

MAINTAINER Munjal Patel <munjalpatel@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install node.js, then npm install yo and the generators
RUN apt-get -yq update && \
    apt-get -yq install git curl net-tools sudo bzip2 libpng-dev locales-all

RUN curl -sL https://deb.nodesource.com/setup | bash - && \
    apt-get -yq install nodejs

RUN npm install -g npm@latest&& \
    npm install -g yo bower grunt-cli && \
    npm install -g generator-angular

# Add an xroot user because grunt doesn't like being root
RUN adduser --disabled-password --gecos "" xroot && \
  echo "xroot ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Expose the port
EXPOSE 4000

# set HOME so 'npm install' and 'bower install' don't write to /
ENV HOME /home/xroot

ENV LANG en_US.UTF-8

RUN mkdir /src && chown xroot:xroot /src
WORKDIR /src

ADD set_env.sh /usr/local/sbin/
RUN chmod +x /usr/local/sbin/set_env.sh
ENTRYPOINT ["set_env.sh"]

# Always run as the xroot user
USER xroot

# Set aliases
RUN echo "alias ls='ls --color=auto'" >> /xroot/.bashrc
RUN echo "alias ll='ls --color=auto -l'" >> /xroot/.bashrc
RUN echo "alias l='ls --color=auto -lA'" >> /xroot/.bashrc
RUN echo "alias c='clear'" >> /xroot/.bashrc

CMD /bin/bash
