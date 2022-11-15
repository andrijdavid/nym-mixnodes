[![Docker Repository on Quay](https://quay.io/repository/andrijdavid/nym-mixnode/status "Docker Repository on Quay")](https://quay.io/repository/andrijdavid/nym-mixnode)
![Docker build](https://github.com/andrijdavid/nym-mixnodes/actions/workflows/docker.yml/badge.svg)


# Nym MixNode using docker


Instruction to launch [Nym](https://nymtech.net/) mixnodes using docker.

1- First step install docker, you can follow those steps: https://docs.docker.com/engine/install/

2- Enable ipv6 in docker, https://docs.docker.com/config/daemon/ipv6/

3- Pull the docker image, `docker pull quay.io/andrijdavid/nym-mixnode:1.0.2`

4- Create a directory `data` to store your configuration file and private keys. Make sure to backup those later. 

5- You can use the image for regular command for example:
`docker run --rm -v $PWD/data:/home/nym/.nym -it quay.io/andrijdavid/nym-mixnode:1.0.2 init --help`

6- To generate the configuration file and keys, 
`docker run --rm -v $PWD/data:/home/nym/.nym -it quay.io/andrijdavid/nym-mixnode:1.0.2 init --id <node_id> --host $(curl ifconfig.me) --wallet-address <wallet_address>`

7- To run the node `docker run -p 1789:1789 -p 1790:1790 -p 8000:8000 -v $PWD/data:/home/nym/.nym --name nym-mixnode -d --restart always -it quay.io/andrijdavid/nym-mixnode:1.0.2 run --id <node_id>`

THAT'S ALL FOLKS

NYM: n1lgkmc0msem75zxhx23ra0qe8tywevh3lreq7h5