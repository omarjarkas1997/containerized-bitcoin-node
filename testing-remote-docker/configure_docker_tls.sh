#!/bin/bash

# Define the directory where the certificates are stored
CERT_DIR="/home/omarjarkas/Desktop/blockchain-work/containerizing-bitcoin-node/testing-remote-docker/server-key-testing"

# Backup the existing Docker service file
echo "Backing up the original Docker service file..."
sudo cp /lib/systemd/system/docker.service /lib/systemd/system/docker.service.bak

# Modify the Docker service file
echo "Modifying Docker service configuration to enable TLS..."
sudo sed -i "/ExecStart=/c\ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2376 --tlsverify --tlscacert=$CERT_DIR/ca.pem --tlscert=$CERT_DIR/server-cert.pem --tlskey=$CERT_DIR/server-key.pem" /lib/systemd/system/docker.service

# Reload systemd to apply changes
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Restart Docker service to apply changes
echo "Restarting Docker service..."
sudo systemctl restart docker

echo "Docker has been configured to use TLS and restarted successfully."
