#!/bin/bash
chmod +x /root/noVNC/utils/novnc_proxy
chmod +x /root/noVNC/utils/websockify/run
Xvfb :1 -screen 0 ${VNC_RESOLUTION}x${VNC_COL_DEPTH} &
x11vnc -display :1 -passwd ${VNC_PASSWORD} -xkb -forever -shared -rfbport ${VNC_PORT} &
/root/noVNC/utils/novnc_proxy --vnc 0.0.0.0:${VNC_PORT} --listen ${NOVNC_PORT} &
qq --no-sandbox &
tail -f /dev/null