# 基础镜像和系统依赖
FROM --platform=linux/amd64 ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# 使用更可靠的镜像源
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

# 安装基础依赖
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    supervisor \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    openbox \
    python3 \
    python3-pip \
    fonts-noto-cjk \
    git \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# 安装Node.js (使用单个RUN命令安装NVM和Node.js)
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://gitee.com/mirrors/nvm/raw/v0.39.7/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 22 && \
    nvm alias default 22 && \
    nvm use default && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.bashrc

# 创建全局Node.js命令链接
RUN . "$NVM_DIR/nvm.sh" && \
    ln -sf "$(which node)" /usr/local/bin/node && \
    ln -sf "$(which npm)" /usr/local/bin/npm

# 验证Node.js版本
RUN node -v && npm -v

# 安装Playwright
RUN . "$NVM_DIR/nvm.sh" && \
    npm install -g playwright@1.40.0 && \
    npx playwright install --with-deps chromium firefox webkit

# 设置环境变量
ENV DISPLAY=:1
ENV RESOLUTION=1280x800x24
ENV NO_VNC_PORT=6080
ENV VNC_PORT=5901

# 创建日志目录
RUN mkdir -p /var/log/supervisor

# 复制配置文件
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 暴露端口
EXPOSE 5901 6080 3000

# 设置入口点
ENTRYPOINT ["/entrypoint.sh"]
