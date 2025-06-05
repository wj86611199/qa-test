#!/bin/bash
set -e

# 启动supervisord
#/usr/bin/supervisord - 这是 supervisord 程序的完整路径，它是一个进程控制系统，用于监控和控制多个进程。
#-n - 这个参数表示 "nodaemon"，意味着 supervisord 将在前台运行，而不是作为守护进程在后台运行。在 Docker 容器中，这是必要的，因为容器需要一个前台进程来保持运行。
#-c /etc/supervisor/supervisord.conf - 这个参数指定了 supervisord 的配置文件路径。这个配置文件定义了 supervisord 应该管理哪些进程（在当前例子中是 VNC 服务器和 websockify）。
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
