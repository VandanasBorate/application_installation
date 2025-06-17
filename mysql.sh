#!/bin/bash
set -e

# Set your MySQL root password here
MYSQL_ROOT_PASSWORD="Root123"   # CHANGE THIS!

export DEBIAN_FRONTEND=noninteractive

# Update and install prerequisites
apt-get update
apt-get install -y wget gnupg lsb-release debconf-utils

# Download MySQL APT config package
wget -q https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb

# Auto-select default options for MySQL APT config (no prompt)
echo "mysql-apt-config mysql-apt-config/select-server select mysql-8.0" | debconf-set-selections
dpkg -i mysql-apt-config_0.8.29-1_all.deb

# Update package index again after adding MySQL repo
apt-get update

# Pre-seed MySQL root password
echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | debconf-set-selections

# Install MySQL Server non-interactively
apt-get install -y mysql-server

# Enable and start MySQL service
systemctl enable mysql
systemctl start mysql

# Output MySQL version to confirm installation
mysql --version

echo "MySQL root password: $MYSQL_ROOT_PASSWORD"
