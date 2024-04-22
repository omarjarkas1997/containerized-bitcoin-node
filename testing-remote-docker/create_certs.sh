#!/bin/bash

# Define the directory for storing the keys and certificates
KEY_DIR="server-key-testing"

# Create the directory
mkdir -p $KEY_DIR

# Step 1: Create CA Key and Certificate
echo "Creating CA key and certificate..."
openssl genrsa -aes256 -out "$KEY_DIR/ca-key.pem" 4096
openssl req -new -x509 -days 365 -key "$KEY_DIR/ca-key.pem" -sha256 -out "$KEY_DIR/ca.pem" -subj "/CN=My Test CA"

# Step 2: Create the Server Key and Certificate Signing Request (CSR)
echo "Creating server key and CSR..."
openssl genrsa -out "$KEY_DIR/server-key.pem" 4096
openssl req -subj "/CN=server" -sha256 -new -key "$KEY_DIR/server-key.pem" -out "$KEY_DIR/server.csr"

# Create a server certificate extension file
echo "Creating server certificate extension file..."
echo subjectAltName = IP:10.89.114.188 > "$KEY_DIR/extfile.cnf"
echo extendedKeyUsage = serverAuth >> "$KEY_DIR/extfile.cnf"

# Step 3: Sign the server CSR with your CA key
echo "Signing server CSR with CA key..."
openssl x509 -req -days 365 -sha256 -in "$KEY_DIR/server.csr" -CA "$KEY_DIR/ca.pem" -CAkey "$KEY_DIR/ca-key.pem" -CAcreateserial -out "$KEY_DIR/server-cert.pem" -extfile "$KEY_DIR/extfile.cnf"

# Step 4: Create the Client Key and CSR
echo "Creating client key and CSR..."
openssl genrsa -out "$KEY_DIR/client-key.pem" 4096
openssl req -subj "/CN=client" -new -key "$KEY_DIR/client-key.pem" -out "$KEY_DIR/client.csr"

# Create a client certificate extension file
echo "Creating client certificate extension file..."
echo extendedKeyUsage = clientAuth > "$KEY_DIR/extfile-client.cnf"

# Step 5: Sign the client CSR with your CA key
echo "Signing client CSR with CA key..."
openssl x509 -req -days 365 -sha256 -in "$KEY_DIR/client.csr" -CA "$KEY_DIR/ca.pem" -CAkey "$KEY_DIR/ca-key.pem" -CAcreateserial -out "$KEY_DIR/client-cert.pem" -extfile "$KEY_DIR/extfile-client.cnf"

echo "Certificate creation complete. Files are stored in $KEY_DIR"