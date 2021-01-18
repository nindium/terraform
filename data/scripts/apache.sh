#!/bin/bash

yum update -y
yum install httpd -y

systemctl enable httpd
echo "<h1>Cloudiar simple app </h1>" > /var/www/html/index.html
systemctl start httpd
