#!/bin/bash

# Define MySQL Router parameters
MYSQL_ROUTER_DIR="/home/devops/mysqlrouter"    # Path where MySQL Router will be installed
MYSQL_HOST="devops@192.168.80.49:3306"         # Adjust primary node address as needed
USER="root"                                    # User for starting the router
SERVICE_NAME="mysqlrouter.service"             # Systemd service file name

# Step 1: Install MySQL Router
echo "Installing MySQL Router..."
sudo apt-get update
sudo apt-get install -y mysql-router

# Step 2: Bootstrap MySQL Router (using the primary node)
echo "Bootstrapping MySQL Router..."
mysqlrouter --bootstrap $MYSQL_HOST --directory $MYSQL_ROUTER_DIR --user=$USER

# Step 3: Create systemd service file
echo "Creating systemd service file for MySQL Router..."
cat <<EOL | sudo tee /etc/systemd/system/$SERVICE_NAME
[Unit]
Description=MySQL Router Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/bin/bash $MYSQL_ROUTER_DIR/start.sh
ExecStop=/bin/bash $MYSQL_ROUTER_DIR/stop.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

# Step 4: Reload systemd and enable the service to start at boot
echo "Reloading systemd configuration..."
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME

# Step 5: Start the MySQL Router service
echo "Starting MySQL Router service..."
sudo systemctl start $SERVICE_NAME

# Step 6: Verify the service is running
echo "Verifying MySQL Router service status..."
sudo systemctl status $SERVICE_NAME

echo "MySQL Router has been successfully deployed and started!"
