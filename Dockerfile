FROM ubuntu:jammy AS ubuntu
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    xfce4 xfce4-goodies x11vnc \
    libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 \
    xdg-utils libatspi2.0-0 libsecret-1-0 unzip \
    libgbm1 libasound2 xvfb curl git \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y git \
    && git clone https://github.com/novnc/noVNC.git /root/noVNC \
    && ln -s /root/noVNC/vnc_lite.html /root/noVNC/index.html

RUN curl https://dldir1.qq.com/qqfile/qq/QQNT/852276c1/linuxqq_3.2.5-21453_amd64.deb -o /tmp/qqnt.deb \
    && dpkg -i /tmp/qqnt.deb \
    && rm /tmp/qqnt.deb

ENV pluginsDir="/opt/LiteLoader/plugins" \
    pluginStoreFolder="/opt/LiteLoader/plugins/pluginStore"

RUN git clone https://mirror.ghproxy.com/github.com/LiteLoaderQQNT/LiteLoaderQQNT.git /tmp/LiteLoader \
    && cp -f /tmp/LiteLoader/src/preload.js /opt/QQ/resources/app/application/preload.js \
    && mv -f /tmp/LiteLoader "$pluginsDir" \
    && echo "require('/opt/LiteLoader');\nrequire('./launcher.node').load('external_index', module);" > /opt/QQ/resources/app/app_launcher/index.js \
    && chmod -R 0777 /opt/LiteLoader

RUN mkdir -p "$pluginStoreFolder" \
    && git clone https://github.com/Night-stars-1/LiteLoaderQQNT-Plugin-Plugin-Store "$pluginStoreFolder/pluginStore"

RUN curl https://github.com/andbutor/LiteLoaderQQNT-Onebot/raw/main/LLOnebot.zip -o /tmp/LLOnebot.zip \
    && curl https://github.com/Night-stars-1/LiteLoaderQQNT-Plugin-LLAPI/archive/refs/heads/main.zip -o /tmp/LLAPI.zip \
    && unzip /tmp/LLOnebot.zip -d "$pluginsDir" \
    && unzip /tmp/LLAPI.zip -d "$pluginsDir" \
    && rm -rf /tmp/LLOnebot.zip /tmp/LLAPI.zip /tmp/LiteLoader

RUN apt-get clean

ENV DISPLAY=:1 \
    VNC_PORT=5900 \
    NOVNC_PORT=6080 \
    VNC_RESOLUTION=1280x800 \
    VNC_COL_DEPTH=24 \
    VNC_PASSWORD=password

EXPOSE 5900 6080

CMD ["/bin/bash"]
