# 基础镜像
FROM jenkins/jenkins:2.346.3-lts-jdk8

# 作者
MAINTAINER Rong.Jia 852203465@qq.com

ENV YARN_VERSION 1.22.19
ENV NODE_VERSION 18.17.0
ENV MVN_VERSION 3.8.4
ENV GRADLE_VERSION 8.0.1
ENV DOCKER_COMPOSE_VERSION 2.20.1

# 切换root用户
USER root

RUN sed -i s/deb.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list \
    && sed -i s/security.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  \
    && echo 'Asia/Shanghai' >/etc/timezone

# 安装依赖
RUN apt-get update \
    && apt-get install -y sudo \
    && apt-get install -y wget \
    && apt-get install -y unzip \
    && apt-get install -y git \
    && apt-get install -y curl \
    && apt-get install -y locales  \
    && apt-get install -y libtool libltdl7 libltdl-dev \
    && apt-get -y install ttf-wqy-zenhei  \
    && apt-get -y install xfonts-intl-chinese  \
    && dpkg-reconfigure locales  \
    && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /opt

# 添加依赖
RUN wget https://archive.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz \
    && wget https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v${NODE_VERSION}-linux-x64.tar.gz \
    && wget https://mirrors.cloud.tencent.com/gradle/gradle-${GRADLE_VERSION}-bin.zip \
    && wget https://github.com/yarnpkg/yarn/releases/download/v$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz \
    && tar zxvf apache-maven-${MVN_VERSION}-bin.tar.gz \
    && tar zxvf node-v${NODE_VERSION}-linux-x64.tar.gz \
    && unzip gradle-${GRADLE_VERSION}-bin.zip \
    && tar zxvf yarn-v$YARN_VERSION.tar.gz \
    && rm -rf gradle-${GRADLE_VERSION}-bin.zip \
    && rm -rf node-v${NODE_VERSION}-linux-x64.tar.gz \
    && rm -rf apache-maven-${MVN_VERSION}-bin.tar.gz \
    && rm -rf yarn-v$YARN_VERSION.tar.gz

WORKDIR /

# 安装 maven node gradle yarn cnpm
RUN ln -s /opt/apache-maven-$MVN_VERSION/bin/mvn /usr/bin/mvn \
    && ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/node /usr/bin/node \
    && ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/npm /usr/bin/npm \
    && ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/npx /usr/bin/npx \
    && ln -s /opt/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && npm install cnpm -g --registry=http://registry.npmmirror.com \
    && ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/cnpm /usr/bin/cnpm \
    && npm config set registry http://registry.npmmirror.com \
    && yarn config set registry http://registry.npmmirror.com

# 安装docker
RUN curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun \
    && curl -L https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# 切换jenkins用户
USER Jenkins














