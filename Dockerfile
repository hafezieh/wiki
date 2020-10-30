FROM 192.168.1.50:8082/ubuntu:18.04 AS cloner
RUN apt-get update
RUN apt-get install -y git
RUN mkdir /home/wiki
WORKDIR /home/wiki
RUN git clone https://github.com/miladamery/wiki.git

FROM 192.168.1.50:8082/squidfunk/mkdocs-material as wiki
RUN mkdir /home/docs
COPY --from=cloner /home/wiki/wiki /home/docs
WORKDIR /home/docs
RUN mkdocs build

FROM 192.168.1.50:8082/nginx as nginx
COPY --from=wiki /home/docs/site /usr/share/nginx/html
