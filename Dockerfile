#
# Nginx image with Consul Template, based on Alpine Linux
#
FROM nginx:1.13-alpine
MAINTAINER Sergey Plesovskykh <ples207@rambler.ru>

RUN apk update && apk upgrade && \
    apk add curl wget bash tree unzip less vim

# Consul template for configuration management
ENV S6_OVERLAY_VERSION=1.19.1.1 CONSUL_TEMPLATE_VERSION=0.18.2

# Install S6 Overlay and Consul Template
RUN curl -Ls https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar -xz -C /
RUN curl -Ls https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template.zip && \
    unzip consul-template.zip -d /usr/local/bin && \
    rm -f consul-template* && \
    echo -ne "- with `consul-template -v 2>&1`\n" >> /root/.built

# Add services configuration
ADD /etc /etc

ENTRYPOINT ["/init"]
CMD ["main.sh"]
