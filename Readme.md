[![Docker Repository on Quay](https://quay.io/repository/andrijdavid/nym-mixnode/status "Docker Repository on Quay")](https://quay.io/repository/andrijdavid/nym-mixnode)
![Docker build](https://github.com/andrijdavid/nym-mixnodes/actions/workflows/docker.yml/badge.svg)

# Nym Node - Dockerized Version

This is a dockerized version of [Nym Node](https://nymtech.net/), allowing you to run a Nym mixnode using Docker containers.

## About Nym Node

Nym nodes are the core routing infrastructure of the Nym mixnet, providing network-level privacy by mixing and routing traffic through multiple layers. For complete documentation about Nym nodes, please visit the [official Nym documentation](https://nym.com/docs/operators/nodes).

## Prerequisites

Before starting, make sure you have:

1. **Docker installed** - Follow the installation instructions at https://docs.docker.com/engine/install/
2. **IPv6 enabled in Docker** - Follow the guide at https://docs.docker.com/config/daemon/ipv6/
3. **A VPS with proper network configuration** - See [VPS setup guide](https://nym.com/docs/operators/nodes/preliminary-steps/vps-setup)
4. **Nym wallet prepared** - See [wallet preparation guide](https://nym.com/docs/operators/nodes/preliminary-steps/wallet-preparation)

## Quick Start

### 1. Pull the Docker Image

```bash
docker pull quay.io/andrijdavid/nym-mixnode:latest
```

Images are tagged with the upstream Nym release (e.g. `2025.8-tourist` and `nym-binaries-v2025.8-tourist`) so you can pin to an exact version if needed.

### 2. Create Data Directory

Create a directory to store your configuration file and private keys. **Make sure to backup this directory!**

```bash
mkdir data
```

### 3. Initialize the Node

Initialize your node with a unique ID, your public IP, and your wallet address:

```bash
docker run --rm -v $PWD/data:/home/nym/.nym -it quay.io/andrijdavid/nym-mixnode:latest \
  init --id <node_id> --host $(curl -s ifconfig.me) --wallet-address <wallet_address>
```

Replace:
- `<node_id>` with a unique identifier for your node
- `<wallet_address>` with your Nym wallet address

### 4. Run the Node

Start the node with the required port mappings:

```bash
docker run -p 1789:1789 -p 1790:1790 -p 8000:8000 \
  -v $PWD/data:/home/nym/.nym \
  --name nym-mixnode \
  -d --restart always \
  quay.io/andrijdavid/nym-mixnode:latest \
  run --id <node_id> --accept-operator-terms-and-conditions
```

**Important:** The `--accept-operator-terms-and-conditions` flag is required (for version 1.1.3 onward) to accept the [Operators Terms & Conditions](https://nymtech.net/terms-and-conditions/operators/v1.0.0). Make sure to read them before adding this flag.

### 5. Bond Your Node

After your node is running, you need to bond it to the Nym network using the Nym wallet. Follow the [bonding guide](https://nym.com/docs/operators/nodes/nym-node/bonding) for detailed instructions.

## Additional Commands

You can use the Docker image for any nym-node command. For example, to see available options:

```bash
docker run --rm -v $PWD/data:/home/nym/.nym -it quay.io/andrijdavid/nym-mixnode:latest --help
```

## Port Configuration

The following ports are exposed by the container:
- **1789** - Mix port
- **1790** - Verloc port
- **8000** - HTTP API port
- **80** - HTTP (optional, for reverse proxy)
- **443** - HTTPS (optional, for reverse proxy)

## Further Configuration

For advanced configuration including:
- Automation and systemd alternatives
- Wireguard configuration
- WSS (WebSocket Secure) setup
- Reverse proxy configuration

Please refer to the [official configuration guide](https://nym.com/docs/operators/nodes/nym-node/configuration).

## Support

If you encounter any issues or have questions, please reach out in the [Nym Operators Matrix channel](https://matrix.to/#/#operators:nymtech.chat).

## Documentation

For complete documentation about running Nym nodes, visit:
- [Nym Node Documentation](https://nym.com/docs/operators/nodes)
- [Setup Guide](https://nym.com/docs/operators/nodes/nym-node/setup)
- [Configuration Guide](https://nym.com/docs/operators/nodes/nym-node/configuration)
- [Bonding Guide](https://nym.com/docs/operators/nodes/nym-node/bonding)

---

NYM Donation Address: n1lgkmc0msem75zxhx23ra0qe8tywevh3lreq7h5
