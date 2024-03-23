#!/bin/bash

yum install -y httpd
systemctl enable --now httpd

echo "Hello, world!" > /var/www/html/index.html