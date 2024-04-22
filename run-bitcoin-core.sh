#!/bin/bash

set -x

# Set the RPCAUTH variable (replace this with your actual output)
source .env

# Run the Bitcoin Core Docker container with the generated rpcauth
docker run --rm -it \
  -p 8332:8332 \
  -p 8333:8333 \
  ruimarinho/bitcoin-core \
  -printtoconsole \
  -rpcallowip=0.0.0.0/0 \
  -rpcbind=0.0.0.0 \
  -rpcauth="$RPCAUTH"

set +x