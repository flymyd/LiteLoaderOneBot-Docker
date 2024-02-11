FROM ubuntu:jammy AS ubuntu
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    xfce4 xfce4-goodies x11vnc \
    libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 \
    xdg-utils libatspi2.0-0 libsecret-1-0 unzip \
    libgbm1 libasound2 xvfb curl git \
    && rm -rf /var/lib/apt/lists/*

COPY noVNC-1.4.0.zip /root
RUN unzip /root/noVNC-1.4.0.zip -d /root/noVNC \
    && rm /root/noVNC-1.4.0.zip \
    && ln -s /root/noVNC/vnc_lite.html /root/noVNC/index.html

COPY qqnt.deb /tmp
RUN dpkg -i /tmp/qqnt.deb \
    && rm /tmp/qqnt.deb
# RUN curl https://dldir1.qq.com/qqfile/qq/QQNT/852276c1/linuxqq_3.2.5-21453_amd64.deb -o /tmp/qqnt.deb \
#     && dpkg -i /tmp/qqnt.deb \
#     && rm /tmp/qqnt.deb

ENV pluginsDir="/opt/LiteLoader/plugins" \
    pluginStoreFolder="/opt/LiteLoader/plugins/pluginStore"


COPY LiteLoaderQQNT.zip /tmp
RUN unzip /tmp/LiteLoaderQQNT.zip -d /tmp/LiteLoader \
    && rm /tmp/LiteLoaderQQNT.zip  
RUN cp -f /tmp/LiteLoader/src/preload.js /opt/QQ/resources/app/application/preload.js \
    && mv -f /tmp/LiteLoader "$pluginsDir" \
    && echo "require('/opt/LiteLoader');\nrequire('./launcher.node').load('external_index', module);" > /opt/QQ/resources/app/app_launcher/index.js \
    && chmod -R 0777 /opt/LiteLoader
# RUN git clone https://mirror.ghproxy.com/github.com/LiteLoaderQQNT/LiteLoaderQQNT.git /tmp/LiteLoader \
#     && cp -f /tmp/LiteLoader/src/preload.js /opt/QQ/resources/app/application/preload.js \
#     && mv -f /tmp/LiteLoader "$pluginsDir" \
#     && echo "require('/opt/LiteLoader');\nrequire('./launcher.node').load('external_index', module);" > /opt/QQ/resources/app/app_launcher/index.js \
#     && chmod -R 0777 /opt/LiteLoader

COPY LiteLoaderQQNT-Plugin-Plugin-Store.zip /tmp
RUN mkdir -p "$pluginStoreFolder" \
    && unzip /tmp/LiteLoaderQQNT-Plugin-Plugin-Store.zip -d "$pluginStoreFolder/pluginStore" \
    && rm /tmp/LiteLoaderQQNT-Plugin-Plugin-Store.zip
# RUN mkdir -p "$pluginStoreFolder" \
#     && git clone https://github.com/Night-stars-1/LiteLoaderQQNT-Plugin-Plugin-Store "$pluginStoreFolder/pluginStore"

COPY LLOnebot.zip /tmp
COPY LLAPI.zip /tmp
RUN unzip /tmp/LLOnebot.zip -d "$pluginsDir" \
    && unzip /tmp/LLAPI.zip -d "$pluginsDir" \
    && rm -rf /tmp/LLOnebot.zip /tmp/LLAPI.zip /tmp/LiteLoader
# RUN curl https://github.com/andbutor/LiteLoaderQQNT-Onebot/raw/main/LLOnebot.zip -o /tmp/LLOnebot.zip \
#     && curl https://github.com/Night-stars-1/LiteLoaderQQNT-Plugin-LLAPI/archive/refs/tags/v1.3.1.1.zip -o /tmp/LLAPI.zip \
#     && unzip /tmp/LLOnebot.zip -d "$pluginsDir" \
#     && unzip /tmp/LLAPI.zip -d "$pluginsDir" \
#     && rm -rf /tmp/LLOnebot.zip /tmp/LLAPI.zip /tmp/LiteLoader

RUN apt-get clean

ENV DISPLAY=:1 \
    VNC_PORT=5900 \
    NOVNC_PORT=6080 \
    VNC_RESOLUTION=1280x800 \
    VNC_COL_DEPTH=16 \
    VNC_PASSWORD=password

EXPOSE 5900 6080 8080

CMD ["/bin/bash"]
