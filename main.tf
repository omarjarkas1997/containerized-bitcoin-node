terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "bitcoin_core" {
  name = "ruimarinho/bitcoin-core:24-alpine"
}

resource "docker_container" "bitcoin_core" {
  image = docker_image.bitcoin_core.name
  name  = "bitcoin-core"
  rm    = true
  start = true

  ports {
    internal = 8332
    external = 8332
  }

  ports {
    internal = 8333
    external = 8333
  }

  env = [
    "PRINTTOCONSOLE=1",
    "RPCALLOWIP=0.0.0.0/0",
    "RPCBIND=0.0.0.0",
    "RPCAUTH=${data.external.rpc_auth.result["rpcauth"]}"
  ]
}

data "external" "rpc_auth" {
  program = ["bash", "${path.module}/generate-rpcauth.sh"]
}
