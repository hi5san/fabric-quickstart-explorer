# fabric-quickstart-explorer
Experimental docker images (DockerFile) for Hyperledger Fabric + Blockchain Explorer Quick start.

This Dockerfile creates Ubuntu64 18.04LTS (bionic) docker container pre-bundled with Docker within, Blockchain Explorer and other dependent packages required to run Hyperledger Fabric v1.2 release (curr: 1.2.0) and Blochchain Explorer (curr: 3.7).

The base OS container is https://hub.docker.com/r/hi5san/fabric-quickstart/.

# Usage
## Retrieve pre-built docker image from Dockerhub
There is a pre-built image on dockerhub.

`docker pull hi5san/fabric-quickstart-explorer`

Or, you could build locally.
## Building Docker images locally
* Clone Dockerfile.  
`git clone git@github.ibm.com:fabric-book/fabric-quickstart-explorer.git`
* Build docker images and tag it as "fabric-quickstart-explorer".  
`docker build fabric-quickstart-explorer -t fabric-quickstart-explorer`

Note: The pulls/builds of images will take several minutes and approx. 1GB in storage.

## Run docker container and install Fabric network
* Run container

If pulled from remote:  

`docker run --name fabric-book --privileged -it -p 8080:8080 hi5san/fabric-quickstart-explorer` 

or if built locally:

`docker run --name fabric-book --privileged -it -p 8080:8080 fabric-quickstart-explorer`  

Note, the port mappings (8080) are for Explorer.

## Start byfn and connect with Explorer
```shell
$ ./runExplorer.sh
...
```

Connect to http://localhost:8080/.

## Stopping Explorer and byfn
If simply quiting, skip to "Quiting" below.
```shell
^C
$ cd blockchain-explorer
$ ./stop.sh
$ cd ~/fabric-samples/first-network
$ ./byfn.sh down
```

## Quiting
Simply logout from container, then destroy stuff.

Look for the container using `docker ps -a` and call `docker rm {container-Id}`.

Remove your docker images if you want: `docker rmi IMAGE-ID`.

Finally, be sure to call `docker system prune` and `docker volume prune` to clean-up stale files.
