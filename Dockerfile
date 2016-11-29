FROM opensuse:tumbleweed
MAINTAINER Alex Geer <monoflash@gmail.com>

RUN zypper --non-interactive --quiet --gpg-auto-import-keys ref
RUN zypper --non-interactive --quiet up
RUN zypper --non-interactive --quiet in tar curl net-tools ca-certificates git

# Minimal set of tools for compiling and linking applications and Tools and libraries for software development using C/C++ and other
RUN zypper --non-interactive in patterns-openSUSE-devel_basis patterns-openSUSE-devel_C_C++

RUN curl --insecure --silent https://nodejs.org/dist/v7.2.0/node-v7.2.0-linux-x64.tar.xz | xz -d | tar x -C /usr/local
RUN ln -s --directory -v /usr/local/node-v7.2.0-linux-x64 /usr/local/nodejs
RUN echo "export PATH=\$PATH:/usr/local/nodejs/bin" >> /etc/bash.bashrc
RUN cp -v /etc/login.defs /etc/login.defs.origin && cat /etc/login.defs.origin | grep -v ENV_PATH > /etc/login.defs.tmp
RUN cat /etc/login.defs.tmp | grep -v ENV_ROOTPATH > /etc/login.defs && rm /etc/login.defs.tmp
RUN echo "ENV_PATH		PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/nodejs/bin" >> /etc/login.defs
RUN echo "ENV_ROOTPATH		PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/nodejs/bin" >> /etc/login.defs

ENV PATH /usr/local/nodejs/bin:$PATH

RUN update-ca-certificates
RUN npm install -g npm-check@latest
RUN npm install -g typings@latest
RUN npm install -g angular-cli@latest
RUN npm install -g lodash@latest
RUN npm install -g bower@latest
RUN npm install -g grunt@latest
RUN npm install -g gulp@latest
RUN npm install -g async@latest
RUN npm install -g typescript@latest
RUN npm install -g ts-node@latest
RUN npm install -g es6-module-loader@latest
RUN npm install -g es6-shim@latest
RUN npm install -g coffee-script@latest
RUN npm install -g karma-cli@latest
RUN npm cache clean

# Enable systemd
RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done)
RUN rm -f /usr/lib/systemd/system/multi-user.target.wants/*
RUN rm -f /etc/systemd/system/*.wants/*
RUN rm -f /usr/lib/systemd/system/local-fs.target.wants/*
RUN rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*
RUN rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*
RUN rm -f /usr/lib/systemd/system/basic.target.wants/*
ADD systemd/dbus.service /etc/systemd/system/dbus.service
VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]

WORKDIR /home

# for gulp server and gulp live reload
EXPOSE 8000 8080 9000

# Start systemd
CMD ["/usr/lib/systemd/systemd"]
