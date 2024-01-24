#!/bin/bash

# Developer: Asman Mirza
# Email: rambo007.am@gmail.com
# Date: 24 January, 2024

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NOC='\033[0m'

echo_info() {
    echo -e "${ORANGE}$1${NOC}"
}

echo_success() {
    echo -e "${GREEN}$1${NOC}"
}

echo_error() {
    echo -e "${RED}$1${NOC}"
}

REPO_URL="https://github.com/oracle/docker-images.git"
REPO_DIR="docker-images"
DOCKER_IMG_DIR="OracleDatabase/SingleInstance/dockerfiles"
DB_VERSION="19.3.0"
DB_EDITION=e

if [ -d "$REPO_DIR" ]; then
    echo_info "Repository directory $REPO_DIR already exists. Skipping clone..."
else
    echo_info "Cloning Oracle Docker Images repository..."
    git clone $REPO_URL
fi

# Download Oracle Database 19.3.0 ZIP if DB_VERSION is 19.3.0
if [[ $DB_VERSION == "19.3.0" ]]; then
    ZIP_URL="https://download.oracle.com/otn/linux/oracle19c/190000/LINUX.X64_193000_db_home.zip"
    ZIP_FILE="LINUX.X64_193000_db_home.zip"
    if [ ! -f "$REPO_DIR/$DOCKER_IMG_DIR/$DB_VERSION/$ZIP_FILE" ]; then
        echo_info "Downloading Oracle Database 19.3.0 ZIP for version $DB_VERSION..."
        mkdir -p $REPO_DIR/$DOCKER_IMG_DIR/$DB_VERSION
        cd $REPO_DIR/$DOCKER_IMG_DIR/$DB_VERSION
        wget -c --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $ZIP_URL
        if [ $? -ne 0 ]; then
            echo_error "Failed to download Oracle Database ZIP. Exiting script."
            exit 1
        fi
        cd - > /dev/null
    else
        echo_info "Oracle Database ZIP for version $DB_VERSION already downloaded."
    fi
fi
# TODO - SUPPORT FOR OTHER VERSIONS WITH .ZIP OR .RPM TO BE ADDED IF NEEDED

cd $REPO_DIR/$DOCKER_IMG_DIR

echo_info "Building Oracle Database Docker Image..."
./buildContainerImage.sh -v $DB_VERSION -$DB_EDITION

if [ $? -ne 0 ]; then
    echo_error "Oracle Docker image build failed. Exiting script."
    exit 1
else
    echo_success "Oracle Docker image built successfully."
fi
