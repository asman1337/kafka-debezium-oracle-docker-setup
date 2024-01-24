#!/bin/bash

# Developer: Asman Mirza
# Email: rambo007.am@gmail.com
# Date: 24 January, 2024

ojdbc_url="https://download.oracle.com/otn-pub/otn_software/jdbc/233/ojdbc8.jar"
docker_image_name="jdbc-debezium-connect"
debezium_version="latest"
ojdbc_jar="ojdbc8.jar"

echo "Downloading ojdbc8 driver..."
wget -c --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $ojdbc_url

if [ ! -f "$ojdbc_jar" ]; then
    echo "Failed to download ojdbc8 driver."
    exit 1
fi

echo "Building Docker image with ojdbc8..."
docker build -t $docker_image_name .

if [ $? -ne 0 ]; then
    echo "Docker build failed."
    exit 1
fi

# echo "Running docker-compose up..."
# docker-compose up -d

echo "Script completed."
