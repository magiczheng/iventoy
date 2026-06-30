FROM alpine:latest

# 安装运行时依赖（iVentoy 需要一些基础库）
RUN apk add --no-cache \
    bash \
    curl \
    util-linux \
    xorriso \
    && rm -rf /var/cache/apk/*

# 创建工作目录
WORKDIR /opt/iventoy

# 解压下载好的 iVentoy 包（构建时由 CI 下载并放在上下文根目录）
ADD iventoy.tar.gz /opt/iventoy/

# 赋予执行权限
RUN chmod +x /opt/iventoy/iventoy

# 暴露 iVentoy 默认端口（Web 管理界面 & PXE 服务）
EXPOSE 26000 69/udp 4011/udp

# 设置启动命令
ENTRYPOINT ["/opt/iventoy/iventoy"]
CMD ["-h"]
