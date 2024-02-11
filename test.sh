docker build -t liteloader-onebot .
docker run -it --rm --name liteloader-onebot -p 5900:5900 -p 6080:6080 -p 3000:3000 -p 5000:5000 -p 5001:5001 -p 8080:8080 -e VNC_PASSWORD=114514 liteloader-onebot:latest
# docker run -d --name liteloader-onebot -p 5900:5900 -p 6080:6080 -p 3000:3000 -p 5000:5000 -p 5001:5001 -p 8080:8080 -e VNC_PASSWORD=114514 liteloader-onebot:latest