#!/bin/bash

# Create the network (if it doesn't already exist)
docker built -t hw2 .
docker network create hw2-net

# Base directory where node directories will be created

# Starting port number for SSH
base_ssh_port=60000

# Create and start the containers
for i in {0..3}; do
    # Create a directory for each node

    # Calculate the SSH port for this node
    ssh_port=$(($base_ssh_port + $i))

    # Run the container with port mapping
    docker run --name "node$i" -itd --network hw2-net -p $ssh_port:22 hw2
done
