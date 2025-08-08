#!/bin/sh
set -e

# 从 HF 环境变量中获取 Space ID (e.g., "username/spacename")
# 并转换为 URL (e.g., "username-spacename.hf.space")
export SUBDOMAIN_HOST=$(echo $SPACE_ID | sed 's/\//-/g').hf.space

# 使用 envsubst 将环境变量注入模板文件，生成最终的配置文件
envsubst < /etc/frp/frps.ini.template > /etc/frp/frps.ini

echo "Starting frps with following configuration:"
echo "==========================================="
cat /etc/frp/frps.ini
echo "==========================================="

# 启动 frps
/usr/bin/frps -c /etc/frp/frps.ini
