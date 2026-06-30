FROM alpine:latest

# 安装必需依赖（含 glibc 兼容层 + GNU grep）
RUN apk add --no-cache \
    bash \
    curl \
    util-linux \
    xorriso \
    grep \
    libc6-compat \
    gcompat \
    && rm -rf /var/cache/apk/*

WORKDIR /opt/iventoy

# 解压（不依赖顶层目录名）
COPY iventoy.tar.gz /tmp/
RUN tar -xzf /tmp/iventoy.tar.gz -C /tmp && \
    mv /tmp/iventoy-*/* /opt/iventoy/ && \
    rm -rf /tmp/iventoy-* /tmp/iventoy.tar.gz

# 赋予执行权限
RUN chmod +x /opt/iventoy/iventoy.sh && \
    chmod +x /opt/iventoy/lib/iventoy

# 创建持久化目录
RUN mkdir -p /opt/iventoy/data /opt/iventoy/log /opt/iventoy/iso /opt/iventoy/user

EXPOSE 26000 69/udp 4011/udp

ENTRYPOINT ["/opt/iventoy/iventoy.sh"]
CMD ["-R", "start"]
