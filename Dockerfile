# 基础镜像
FROM jenkins/jenkins:lts

# 作者
MAINTAINER Rong.Jia 852203465@qq.com

ENV YARN_VERSION 1.22.10
ENV NODE_VERSION 16.3.0
ENV MVN_VERSION 3.8.1
ENV GRADLE_VERSION  7.0

# 切换root用户
USER root

# 安装依赖
RUN apt-get update \
    && apt-get install -y sudo \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get install -y wget \
    && apt-get install -y unzip
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /opt

# 添加依赖
RUN wget https://mirrors.bfsu.edu.cn/apache/maven/maven-3/$MVN_VERSION/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz \
    && wget https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v${NODE_VERSION}-linux-x64.tar.gz \
    && wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
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

# 安装 maven node
RUN ln -s /opt/apache-maven-$MVN_VERSION/bin/mvn /usr/bin/mvn \
    && ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/node /usr/bin/node \
    && ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/npm /usr/bin/npm \
    && ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/npx /usr/bin/npx \
    && ln -s /opt/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg

# 切换jenkins用户
USER Jenkins














