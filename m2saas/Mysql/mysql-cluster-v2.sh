#!/bin/bash

# MySQL Shell configuration
MYSQLSH_CMD="mysqlsh"
CLUSTER_NAME="innodb_cluster"
PRIMARY_NODE="devops@db1:3306"  # Primary node (adjust accordingly)
NODE_2="devops@db2:3306"        # Node 2 (adjust accordingly)
NODE_3="devops@db3:3306"        # Node 3 (adjust accordingly)

# Function to connect and configure the cluster
configure_cluster() {
  local node=$1
  
  echo "Connecting to $node..."
  
  $MYSQLSH_CMD --uri=$node --sql -e "
    if (dba.getCluster('$CLUSTER_NAME') == null) {
      print('Creating cluster: $CLUSTER_NAME');
      var cluster = dba.createCluster('$CLUSTER_NAME');
    } else {
      print('Cluster '$CLUSTER_NAME' already exists.');
    }
  "
}

# Function to add a node to the cluster
add_node_to_cluster() {
  local node=$1
  
  echo "Adding $node to the cluster..."
  
  $MYSQLSH_CMD --uri=$PRIMARY_NODE --js -e "
    var cluster = dba.getCluster('$CLUSTER_NAME');
    cluster.addInstance('$node');
  "
}

# Main script execution
echo "Configuring InnoDB Cluster..."

# Configure the primary node and create the cluster if it does not exist
configure_cluster $PRIMARY_NODE

# Add Node 2 to the cluster
add_node_to_cluster $NODE_2

# Add Node 3 to the cluster
add_node_to_cluster $NODE_3

echo "Cluster setup and nodes added successfully."
