docker build -t liteloader-onebot .
docker run -it --rm --name liteloader-onebot -p 5900:5900 -p 6080:6080 -p 8080:8080 liteloader-onebot:latest
