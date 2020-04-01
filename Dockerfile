FROM opensuse/tumbleweed:latest
MAINTAINER Alex Geer <monoflash@gmail.com>

RUN echo "update 01.04.2020"
RUN zypper --non-interactive --gpg-auto-import-keys ref
RUN zypper --non-interactive --quiet in net-tools ca-certificates tar gzip curl wget git mercurial subversion
RUN zypper --non-interactive --quiet dup

## Setup the locale
RUN zypper --non-interactive --quiet in gzip glibc-i18ndata glibc-locale translation-update-ru
ENV LANG ru_RU.UTF-8
ENV LC_ALL $LANG
RUN localedef --charmap=UTF-8 --inputfile=ru_RU $LANG

## Установка готовых паттернов
## - Base System
RUN zypper --non-interactive --quiet in -t pattern base
## - Software Management
RUN zypper --non-interactive --quiet in -t pattern sw_management
## - Base Development
RUN zypper --non-interactive --quiet in -t pattern devel_basis
## - C/C++ Development
RUN zypper --non-interactive --quiet in -t pattern devel_C_C++
## - Documentation
RUN zypper --non-interactive --quiet in -t pattern books

## Очистка
RUN zypper --non-interactive clean --all

RUN curl --insecure --silent https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.xz | xz -d | tar x -C /usr/local
RUN ln -s --directory -v /usr/local/node-v12.16.1-linux-x64 /usr/local/nodejs
RUN echo "export PATH=\$PATH:/usr/local/nodejs/bin" >> /etc/bash.bashrc
RUN cp -v /etc/login.defs /etc/login.defs.origin && cat /etc/login.defs.origin | grep -v ENV_PATH > /etc/login.defs.tmp
RUN cat /etc/login.defs.tmp | grep -v ENV_ROOTPATH > /etc/login.defs && rm /etc/login.defs.tmp
RUN echo "ENV_PATH PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/nodejs/bin" >> /etc/login.defs
RUN echo "ENV_ROOTPATH PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/nodejs/bin" >> /etc/login.defs

ENV PATH /usr/local/nodejs/bin:$PATH
RUN npm install -g --silent --unsafe-perm npm@latest
RUN npm install -g --silent npm-check@latest
RUN npm install -g --silent --unsafe-perm @angular/cli@latest

ADD build.bash /usr/sbin/build
RUN chmod 755 /usr/sbin/build
WORKDIR /home

ENTRYPOINT ["/usr/sbin/build"]
