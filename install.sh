#!/bin/bash

Tools="/root/Tools"

apt-get update && apt-get upgrade -y
apt-get install -y python3 python3-pip jq

mkdir $Tools

## Install Golang
wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.14.2.linux-amd64.tar.gz
rm go1.14.2.linux-amd64.tar.gz
echo -e "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile

## Install Nuclei
wget https://github.com/projectdiscovery/nuclei/releases/download/v1.1.3/nuclei-linux-amd64.gz
gunzip nuclei-linux-amd64.gz
mv nuclei-linux-amd64 /usr/bin/nuclei
chmod +x /usr/bin/nuclei

cd $Tools
git clone https://github.com/projectdiscovery/nuclei-templates
cd nuclei-templates
mkdir all
cp $(find . -type f -name '*.yaml') all/

## Install Httprobe
go get -u github.com/tomnomnom/httprobe
mv ~/go/bin/httprobe /usr/bin/

## Install Hakrawler
go get github.com/hakluke/hakrawler
mv ~/go/bin/hakrawler /usr/bin/

## Install Kxss
git clone https://github.com/tomnomnom/hacks
cd hacks/kxss
go build main.go
mv main /usr/bin/kxss
cd ../.. && rm -r hacks/

## Install ParamSpider
cd $Tools
git clone https://github.com/devanshbatham/ParamSpider
cd ParamSpider 
pip3 install -r requirements.txt

## Install JSScanner
cd $Tools
git clone https://github.com/dark-warlord14/JSScanner
cd JSScanner
sed -i 's/tools/Tools/g' script.sh
sed -i 's/tools/Tools/g' install.sh
bash install.sh

## Install ffuf
go get github.com/ffuf/ffuf
mv ~/go/bin/ffuf /usr/bin/

## Install GF
go get -u github.com/tomnomnom/gf
echo 'source /root/go/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc
source ~/.bashrc
cp -r /root/go/src/github.com/tomnomnom/gf/examples ~/.gf
mv ~/go/bin/gf /usr/bin/
cd ~/.gf
cp $Tools/ParamSpider/gf_profiles/* .

## Add more GF patterns
git clone https://github.com/1ndianl33t/Gf-Patterns
mv Gf-Patterns/*.json .

## Download Wordlist
mkdir $Tools/Wordlists
cd $Tools/Wordlists
wget https://raw.githubusercontent.com/jonaslejon/dirs3arch/master/db/dicc.txt