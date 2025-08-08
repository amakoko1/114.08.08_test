# Stage 1: Builder - 下载并解压 frp
FROM alpine:latest AS builder
ARG FRP_VERSION=0.59.0
ARG TARGETARCH

RUN apk add --no-cache curl tar gzip && \
    # 根据架构选择正确的包
    case ${TARGETARCH} in \
        "amd64") ARCH="amd64" ;; \
        "arm64") ARCH="arm64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; \
    esac && \
    FRP_FILENAME="frp_${FRP_VERSION}_linux_${ARCH}" && \
    curl -Lo ${FRP_FILENAME}.tar.gz "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/${FRP_FILENAME}.tar.gz" && \
    tar -zxvf ${FRP_FILENAME}.tar.gz && \
    mv ${FRP_FILENAME}/frps /frps

# Stage 2: Final Image - 创建一个极简的运行环境
FROM alpine:latest
RUN apk add --no-cache gettext

COPY --from=builder /frps /usr/bin/frps
COPY frps.ini.template /etc/frp/frps.ini.template
COPY run.sh /run.sh

RUN chmod +x /run.sh

# 暴露 HF 的默认端口
EXPOSE 7860

# 运行启动脚本
CMD ["/run.sh"]
