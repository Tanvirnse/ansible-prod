#!/bin/bash

# Step 1: Log into MySQL as root and create the user 'devops'
echo "Creating MySQL user 'devops'..."

# Run the MySQL commands to create the user and grant privileges
mysql -u root <<EOF
CREATE USER 'devops'@'%' IDENTIFIED BY 'DevOps@2025#';
GRANT ALL PRIVILEGES ON *.* TO 'devops'@'%' WITH GRANT OPTION;
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'devops'@'%';
FLUSH PRIVILEGES;
EOF

# Step 2: Output success message
echo "User 'devops' created and privileges granted successfully."
