#!/bin/bash

# Step 1: Download MySQL APT configuration package
echo "Downloading MySQL APT configuration package..."
wget https://dev.mysql.com/get/mysql-apt-config_0.8.33-1_all.deb

# Step 2: Install the MySQL APT configuration package
echo "Installing MySQL APT configuration package..."
sudo dpkg -i mysql-apt-config_0.8.33-1_all.deb

# Step 3: Update the package repository list
echo "Updating package repositories..."
sudo apt-get update

# Step 4: Install MySQL server and MySQL Shell
echo "Installing MySQL Community Server and MySQL Shell..."
sudo apt-get install -y mysql-community-server mysql-shell

# Step 5: Retrieve the actual IP address of the node
NODE_IP=$(hostname -I | awk '{print $1}')
if [ -z "$NODE_IP" ]; then
  echo "Unable to retrieve IP address, exiting."
  exit 1
fi
echo "Node IP address: $NODE_IP"

# Step 6: Configure MySQL Server
echo "Configuring MySQL server..."

# Backup current mysqld.cnf file before modifying
sudo cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.bak

# Append the required configuration to the mysqld.cnf file
echo "[mysqld]" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null
echo "enforce_gtid_consistency = ON" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null
echo "gtid_mode = ON" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null
echo "server_id = 1" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null
echo "report_host = $NODE_IP" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null
echo "socket = /var/lib/mysql/mysql.sock" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null

# Step 7: Restart MySQL service
echo "Restarting MySQL service..."
sudo systemctl restart mysql

# Step 8: Output success message
echo "MySQL installation and configuration completed successfully."
