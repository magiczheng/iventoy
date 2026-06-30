FROM alpine:latest

# 安装运行时依赖
RUN apk add --no-cache \
    bash \
    curl \
    util-linux \
    xorriso \
    grep \
    && rm -rf /var/cache/apk/*

# 创建工作目录
WORKDIR /opt/iventoy

# 解压并去除顶层目录
COPY iventoy.tar.gz /tmp/
RUN tar -xzf /tmp/iventoy.tar.gz -C /opt/iventoy --strip-components=1 && \
    rm /tmp/iventoy.tar.gz

# 赋予执行权限
RUN chmod +x /opt/iventoy/iventoy.sh && \
    chmod +x /opt/iventoy/lib/iventoy

# 创建持久化目录
RUN mkdir -p /opt/iventoy/data /opt/iventoy/log /opt/iventoy/iso /opt/iventoy/user

EXPOSE 26000 69/udp 4011/udp

ENTRYPOINT ["/opt/iventoy/iventoy.sh"]
CMD ["-R", "start"]
