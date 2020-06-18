##############################################
# 基于centos7构建miniconda运行环境
# 构建命令: 在Dockerfile文件目录下执行 docker build -t conda2:1.0 .
# 容器启动命令: docker run -itd --name miniconda --restart always --privileged=true -v /Users/carl/workspaces/docker/conda/envs:/opt/conda/envs -v /Users/carl/workspaces/docker/conda/cron:/var/spool/cron conda2:1.0 /usr/sbin/init
# 进入容器：docker exec -it conda2:1.0 /bin/bash
# 或直接启动并进入: docker run -it -v /Users/carl/workspaces/docker/conda/envs:/opt/conda/envs -v /Users/carl/workspaces/docker/conda/cron:/var/spool/cron conda2:1.0 /bin/bash
##############################################
FROM centos:7.8.2003
MAINTAINER v12know # 指定作者信息
RUN set -ex \
    # 预安装所需组件
    && yum install -y wget \
    && yum groupinstall -y "Development Tools" \
    && wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda2-latest-Linux-x86_64.sh \
    && chmod +x ./Miniconda2-latest-Linux-x86_64.sh \
    && ./Miniconda2-latest-Linux-x86_64.sh -b -p /opt/conda \
    && echo export PATH="/opt/conda/bin:\$PATH" | cat >> ~/.bashrc \
    && source ~/.bashrc

# 基础环境配置
RUN set -ex \
    # 修改系统时区为东八区
    && rm -rf /etc/localtime \
    && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum install -y vim \
    # 安装定时任务组件
    && yum -y install cronie
# 支持中文
RUN yum install kde-l10n-Chinese -y
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
ENV LC_ALL zh_CN.UTF-8
# 做一些清理工作
RUN set -ex \
    && rm -rf ./Miniconda2-latest-Linux-x86_64.sh ./anaconda-post.log /tmp/* /var/log/* /usr/src/* \
    # for clean /var/cache (if ubuntu: apt-get autoclean)
    && yum clean all
    
