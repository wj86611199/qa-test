#!/bin/bash
set -e

# 确保日志目录存在
mkdir -p /var/log/supervisor

# 启动supervisord
exec /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
