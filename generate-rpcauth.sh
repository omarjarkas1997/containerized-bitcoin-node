#!/bin/bash

# Static username for demonstration. Replace or modify as needed.

source .env

BASEDIR=$(dirname "$0")

# Generate the RPC auth using the rpcauth.py script
OUTPUT=$(python3 "${BASEDIR}/rpcauth.py" $USERNAME)

# Parse out rpcauth and password from the OUTPUT assuming the python script outputs JSON
RPCAUTH=$(echo "$OUTPUT" | jq -r '.rpcauth')
PASSWORD=$(echo "$OUTPUT" | jq -r '.password')

# Produce a flat JSON output
echo "{\"rpcauth\":\"${RPCAUTH}\", \"password\":\"${PASSWORD}\"}"
