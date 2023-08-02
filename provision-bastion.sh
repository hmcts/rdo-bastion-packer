#!/bin/bash -xe

export DEBIAN_FRONTEND=noninteractive

apt autoremove -y

apt update

apt install -y \
  ca-certificates \
  curl \
  gnupg \
  gnupg2 \
  lsb-release

curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main | tee /etc/apt/sources.list.d/azure-cli.list

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

apt-get update
apt-get upgrade -y

apt update

apt install -y azure-cli apt-transport-https ca-certificates curl gnupg jq kubectl lsb-release nmap openjdk-11-jre-headless openjdk-17-jre-headless postgresql tcpdump parallel redis-server
# apt-get -y install apt-transport-https azure-cli ca-certificates curl gnupg jq kubectl lsb-release nmap openjdk-11-jre-headless openjdk-17-jre-headless postgresql tcpdump parallel redis-server

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
