FROM nginx

RUN apt-get update && \
  apt-get install -y --no-install-recommends apache2-utils inotify-tools \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/nginx

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT []

CMD ["/opt/nginx/entrypoint.sh"]
