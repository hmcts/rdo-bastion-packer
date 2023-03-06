## Overview 

This repository contains Packer HCL to build and publish an Ubuntu 18.04 machine image to an Azure Shared Image Gallery.

## Adding new packages

If you want to add new software packages to the image, update the provision-bastion.sh script to add the required package:

```
apt-get -y install apt-transport-https azure-cli ca-certificates curl gnupg jq kubectl lsb-release nmap openjdk-11-jre-headless postgresql tcpdump parallel
```

Also add the package name to the checker. When the pipeline runs to create the image, the build will exit if any of the required packages are missing:

```
packages=(az gpg java jq kubectl nmap psql tcpdump)
```

## Deploying updated bastions

If updates are made to the provisioh-bastion.sh script then update the azure_image_version variable to increment the version within ubuntu.pkr.hcl  When this pipeline runs, a new image version will be created in the Shared Image Gallery.

To redeploy the bastions based on the updated image version, update the image_version for each environment in the hmcts/bastion repo.
