#!/bin/bash

# 启动Xvfb虚拟显示器
Xvfb $DISPLAY -screen 0 1280x1024x24 -ac +extension GLX +render -noreset > /dev/null 2>&1 &

# 启动Fluxbox窗口管理器
fluxbox > /dev/null 2>&1 &

# 启动x11vnc服务器
x11vnc -display $DISPLAY \
    -passwdfile ~/.vnc/passwd \
    -forever \
    -noxdamage \
    -noxrecord \
    -shared \
    -rfbport 5900 > /dev/null 2>&1 &

# 启动Websockify (NoVNC适配器)
websockify --web /usr/share/novnc 6080 localhost:5900 > /dev/null 2>&1 &

# 环境信息
echo "========================================================================"
echo "VNC环境已启动！"
echo "NoVNC访问: http://localhost:6080/vnc.html?host=localhost&port=6080"
echo "VNC密码: password"
echo "Playwright脚本目录: /scripts"
echo "========================================================================"

# 保持容器运行
tail -f /dev/null
