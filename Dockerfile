#
# Nginx image with Consul Template, based on Alpine Linux
#
FROM lsiobase/alpine.nginx:3.8
MAINTAINER Sergey Plesovskykh <ples207@rambler.ru>

RUN apk update && apk upgrade && \
    apk add curl wget unzip less

# Consul template for configuration management
ENV S6_OVERLAY_VERSION=1.19.1.1 CONSUL_TEMPLATE_VERSION=0.18.2 GNINX_PORT=80 PROXY_HOST=localhost PROXY_PATH=/etc/nginx/nginx_config NODES=web1:80

# Install S6 Overlay and Consul Template
RUN curl -Ls https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar -xz -C /
RUN curl -Ls https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template.zip && \
    unzip consul-template.zip -d /usr/local/bin && \
    rm -f consul-template* && \
    echo -ne "- with `consul-template -v 2>&1`\n" >> /root/.built

RUN apk del curl wget unzip less
RUN mkdir -p /run/nginx

COPY . main.sh /

# Add services configuration
ADD /etc /etc


EXPOSE 8080

ENTRYPOINT ["/init"]
CMD ["main.sh"]
