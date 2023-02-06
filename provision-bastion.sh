#!/bin/bash -xe

export DEBIAN_FRONTEND=noninteractive

curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main | tee /etc/apt/sources.list.d/azure-cli.list

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get upgrade -y

apt-get -y install apt-transport-https azure-cli ca-certificates curl gnupg jq kubectl lsb-release nmap openjdk-17-jre-headless postgresql tcpdump parallel redis-server

packages=(az gpg java jq kubectl nmap psql tcpdump redis-server)

for i in ${packages[@]}

do
  if command -v ${i}; then
     echo -n ${i} is installed. Version is ; ${i} --version
  else
     echo ${i} is missing!
     exit 1
  fi
done
