### Как создать образ nginx под не root пользователем?

```dockerfile
FROM nginx:latest

LABEL maintainer="pi3rre.hernandez@gmail.com"

RUN rm /etc/nginx/nginx.conf /etc/nginx/conf.d/default.conf

#install nginx

RUN apt-get update && apt-get upgrade -y \
    && apt install nano curl -y \ 
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/cache/nginx/client_temp && \
        mkdir -p /var/cache/nginx/proxy_temp && \
        mkdir -p /var/cache/nginx/fastcgi_temp && \
        mkdir -p /var/cache/nginx/uwsgi_temp && \
        mkdir -p /var/cache/nginx/scgi_temp && \
        chown -R nginx:nginx /var/cache/nginx && \
        chown -R nginx:nginx /etc/nginx/ && \
        chmod -R 755 /etc/nginx/ && \
        chown -R nginx:nginx /var/log/nginx

RUN mkdir -p /etc/nginx/ssl/ && \
    chown -R nginx:nginx /etc/nginx/ssl/ && \
    chmod -R 755 /etc/nginx/ssl/

RUN touch /var/run/nginx.pid && \
        chown -R nginx:nginx /var/run/nginx.pid /run/nginx.pid

USER nginx

CMD ["nginx", "-g", "daemon off;"]
```

```yaml
#LOADBALANCER
  nginxlb:
     container_name: Asgard
     build:
      context: ./
      dockerfile: ./web/nginx/Dockerfile
     depends_on:
       - app1
       - app2
     restart: on-failure:5
     ports:
       - 80:80
       - 443:443
     volumes:
       - ./web/nginx/nginx.conf:/etc/nginx/nginx.conf
       - ./certbot/www:/var/www/certbot:ro
       - ./certbot/conf:/etc/nginx/ssl/:ro
     networks:
      loki:
        ipv4_address: 192.168.123.15
     deploy:
      resources:
        limits:
          cpus: "0.3"
          memory: 500M
     healthcheck:
        test: ["CMD", "service", "nginx", "status"]
        interval: 1m
        timeout: 5s
        retries: 3
  #CERTBOT
  certbot:
     container_name: certbot
     image: certbot/certbot:latest
     depends_on:
       - nginxlb
     volumes:
      - ./certbot/www:/var/www/certbot:rw
      - ./certbot/conf/:/etc/letsencrypt/:rw```
```

Взято с https://forums.docker.com/t/running-nginx-official-image-as-non-root/135759/8