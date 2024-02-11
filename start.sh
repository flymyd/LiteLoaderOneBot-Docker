#!/bin/bash
Xvfb :1 -screen 0 ${VNC_RESOLUTION}x${VNC_COL_DEPTH} &
x11vnc -display :1 -passwd ${VNC_PASSWORD} -xkb -forever -shared -rfbport ${VNC_PORT} &
# startxfce4 &  # 可能不需要
cd /root/noVNC && ./utils/novnc_proxy --vnc localhost:${VNC_PORT} --listen ${NOVNC_PORT} &
qq