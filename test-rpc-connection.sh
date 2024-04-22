#!/bin/bash
# Source environment variables
source .env

# Send a test RPC request to get blockchain info
curl --user $USERNAME:$PASSWORD \
     --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' \
     -H 'content-type: text/plain;' \
     http://127.0.0.1:8332/
