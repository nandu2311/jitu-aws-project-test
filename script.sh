#!/bin/bash

  

  echo "Updating Ubuntu"
  sudo apt-get update -y

  echo "Installing Nginx Server"
  sudo apt-get install -y curl nginx awscli

  echo "Service starting and enabling"
  sudo systemctl enable nginx
  sudo systemctl start nginx
  sudo systemctl status nginx

  echo "Creating Nginx configuration file"
  sudo tee /etc/nginx/sites-available/nginx.conf<<EOF
  server {
        listen 80;
        listen [::]:80;
        #root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.htm;

        server_name 	appserver.nritworld.xyz;
        access_log      /var/log/nginx/statics.access.log combined;
        error_log       /var/log/nginx/statics.error.log;

        location  / {
                
                resolver               8.8.8.8;
                proxy_http_version     1.1;
                proxy_set_header       Connection "";
                proxy_set_header       Authorization '';
                proxy_set_header       Host simple-website-testing-vpcendpoint.s3.ap-south-1.amazonaws.com;
                proxy_hide_header      x-amz-id-2;
                proxy_hide_header      x-amz-request-id;
                proxy_hide_header      x-amz-meta-server-side-encryption;
                proxy_hide_header      x-amz-server-side-encryption;
                proxy_hide_header      Set-Cookie;
                proxy_ignore_headers   Set-Cookie;
                proxy_intercept_errors on;
                add_header             Cache-Control max-age=31536000;
                proxy_pass             https://simple-website-testing-vpcendpoint.s3.ap-south-1.amazonaws.com/;
        }

}

EOF

  sudo rm -rf /etc/nginx/sites-available/default

  sudo cd /etc/nginx/sites-enabled

  sudo ln -svf /etc/nginx/sites-available/nginx.conf

  sudo mv /nginx.conf /etc/nginx/sites-enabled

  sudo rm -rf /etc/nginx/sites-enabled/default

