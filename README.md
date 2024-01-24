# Kafka-Debezium with Oracle LogMiner Setup
This guide outlines the setup for Kafka with Debezium and Oracle LogMiner using Docker.

## Table of Contents
- [Kafka-Debezium with Oracle LogMiner Setup](#kafka-debezium-with-oracle-logminer-setup)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Scripts](#scripts)
    - [1. `create_logminer_user.sh`](#1-create_logminer_usersh)
    - [2. `setup_image_docker.sh`](#2-setup_image_dockersh)
    - [3. `run.sh`](#3-runsh)
  - [Connectors](#connectors)
  - [Other Information](#other-information)
  - [Contact](#contact)
---

## Prerequisites

Before you begin, make sure you have the following prerequisites installed and configured on your system:

- [Docker](https://www.docker.com/get-started): Required for running containers.
- [Docker Compose](https://docs.docker.com/compose/install/): Used for managing multi-container Docker applications.
- [Git](https://git-scm.com/downloads): Optional, but useful for cloning the repository.

---

## Setup

To get started with Kafka and Debezium with Oracle LogMiner, follow these steps:

1. Build the Debezium Connect image with OJDBC8:
   ```
   docker build -t jdbc-debezium-connect .
   ```

2. Start the containers using Docker Compose:
   ```
   docker-compose up
   ```

   - Use `docker-compose up -d` to run as a daemon (optional).
   - Use `docker-compose down` to stop the Docker containers.

---

## Scripts

### 1. `create_logminer_user.sh`

This script creates the Oracle LogMiner user with all the required permissions.

### 2. `setup_image_docker.sh`

Use this script to build the Oracle Docker image from the official Oracle docker-images repository. By default, it will build version 19.3.0e.

### 3. `run.sh`

Run this script to start the Docker container with Kafka, Debezium, and the Oracle database with the JDBC connector configured.

---

## Connectors

You can manage connectors using the following commands:

- Get connectors:
  ```
  curl -i -X GET http://localhost:8083/connectors/
  ```

- Load a connector (example using `oracle-logminer.json`):
  ```
  curl -i -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:8083/connectors/ -d @oracle-logminer.json
  ```

- Delete a connector (replace `oracle-connector` with the connector name):
  ```
  curl -i -X DELETE http://localhost:8083/connectors/oracle-connector
  ```
- Check Connector Status:
  ```
  curl -i -X GET http://localhost:8083/connectors/oracle-connector/status
  ```
- List Connector Tasks:
  ```
  curl -i -X GET http://localhost:8083/connectors/oracle-connector/tasks
  ```

You can also check the status and troubleshoot any problems with the connectors.

---

## Other Information

- Kafka Dashboard: [http://0.0.0.0:8080](http://0.0.0.0:8080)
- Kafka Broker: [http://0.0.0.0:9092](http://0.0.0.0:9092)
- Oracle Database: [http://0.0.0.0:1521](http://0.0.0.0:1521)

---

## Contact
- **Developer:** Asman Mirza
- **Email:** rambo007.am@gmail.com
- **Date:** 24 January, 2024