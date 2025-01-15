#!/bin/bash

# Check if Docker is installed
if ! [ -x "$(command -v docker)" ]; then
  echo "Error: Docker is not installed." >&2
  exit 1
fi

# Check if Docker Compose is installed
if ! [ -x "$(command -v docker-compose)" ]; then
  echo "Error: Docker Compose is not installed." >&2
  exit 1
fi

# Create necessary directories and set permissions
if [ ! -d "./oracle-data" ]; then
  echo "Creating directory ./oracle-data for data persistence..."
  mkdir -p ./oracle-data
  # Assign ownership to match Oracle's expected UID:GID (54321)
  sudo chown -R 54321:54321 ./oracle-data
  # Set appropriate permissions
  chmod -R 777 ./oracle-data
  echo "Directory ./oracle-data created and permissions set."
else
  echo "Directory ./oracle-data already exists. Verifying permissions..."
  sudo chown -R 54321:54321 ./oracle-data
  chmod -R 755 ./oracle-data
  echo "Permissions for ./oracle-data have been updated."
fi

# Start services with Docker Compose
echo "Starting services with Docker Compose..."
docker-compose up -d

# Wait for the container to start and the database to be ready
echo "Waiting for Oracle XE database to be ready..."
while true; do
  # Check if the container is running
  CONTAINER_STATUS=$(docker ps --filter "name=oracle-xe" --filter "status=running" -q)
  if [ -z "$CONTAINER_STATUS" ]; then
    echo "Error: The Oracle XE container could not start. Check the logs."
    exit 1
  fi

  # Look for the line "DATABASE IS READY TO USE" in the logs
  if docker logs oracle-xe 2>&1 | grep -q "DATABASE IS READY TO USE"; then
    echo "The Oracle XE database is ready to use."
    break
  fi

  # Wait 5 seconds before trying again
  sleep 5
done

# Show connection details
echo "Connect in IntelliJ IDEA using the following details:"
echo "Host: localhost"
echo "Port: 1521"
echo "SID: XEPDB1"
echo "User: sys as sysdba"
echo "Password: admin_password"