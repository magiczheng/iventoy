FROM alpine:latest

# 安装运行时依赖
RUN apk add --no-cache \
    bash \
    curl \
    util-linux \
    xorriso \
    && rm -rf /var/cache/apk/*

# 创建工作目录
WORKDIR /opt/iventoy

# 将 CI 下载的 tar.gz 复制到容器内并解压（去除顶层目录）
COPY iventoy.tar.gz /tmp/
RUN tar -xzf /tmp/iventoy.tar.gz -C /opt/iventoy --strip-components=1 && \
    rm /tmp/iventoy.tar.gz

# 赋予执行权限
RUN chmod +x /opt/iventoy/iventoy.sh && \
    chmod +x /opt/iventoy/lib/iventoy

# 创建持久化目录（如果不存在）
RUN mkdir -p /opt/iventoy/data /opt/iventoy/log /opt/iventoy/iso /opt/iventoy/user

# 暴露端口：Web 管理界面 26000，TFTP 69，代理 DHCP 4011
EXPOSE 26000 69/udp 4011/udp

# 使用 -R 参数：按照上次配置自动启动 PXE 服务
ENTRYPOINT ["/opt/iventoy/iventoy.sh"]
CMD ["-R", "start"]
