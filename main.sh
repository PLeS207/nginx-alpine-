#!/bin/bash

# Create nginx configuration
cat > etc/nginx/nginx.conf << EOF

daemon off;
worker_processes 8;


events { worker_connections 1024; }



http {

 upstream localhost {
    server 127.0.0.1:3000;
    server 127.0.0.2:3000;
    server 127.0.0.3:3000;
 }

 server {
    listen 8080;
    server_name localhost;

location / {
                proxy_pass http://localhost;
                proxy_http_version 1.1;
                proxy_set_header Upgrade \$http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host \$host;
                proxy_cache_bypass \$http_upgrade;
              }
        }
}

EOF

# Start nginx

nginx -c /nginx.conf
