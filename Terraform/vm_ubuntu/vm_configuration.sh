#!/bin/bash


# Update the package list
sudo apt-get update -y

#install nginx
sudo apt-get install nginx 
systemctl start nginx
systemctl enable nginx

# Download & Install dotnet 6.0

wget https://download.visualstudio.microsoft.com/download/pr/35b1b4d1-b8f4-4b5c-9ddf-e64a846ee50b/93cc198f1c48fe5c4853bd937226f570/dotnet-sdk-6.0.428-linux-x64.tar.gz

sudo mkdir -p /usr/share/dotnet
sudo tar -xvzf dotnet-sdk-6.0.428-linux-x64.tar.gz -C /usr/share/dotnet

sudo ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Download Git 
sudo apt-get install git -y 


