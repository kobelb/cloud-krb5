#! /bin/bash

set -e

echo "Stopping the container if it's already running"
docker stop -t 2 kdc || true

echo "Deleting the container image if it exists"
docker rm kdc || true

echo "ES host. Example: ed9b4eda940546be8de2d57c99cab795.us-central1.gcp.foundit.no"
read -p "> " ES_HOST

echo "Kibana host. Example 7aa29471bda340e88937372d5f1a8adb.us-central1.gcp.foundit.no"
read -p "> " KIBANA_HOST

# Build the container
docker build --build-arg ES_HOST=${ES_HOST} --build-arg KIBANA_HOST=${KIBANA_HOST} -t kdc ./

# Start the container up
docker run -d -p 88:88 -p 88:88/udp --name kdc kdc:latest

# Copy the keytabs we need
docker cp kdc:/root/es.keytab ./
docker cp kdc:/root/dev.keytab ./

# Get the ticket-granting-ticket for the dev user
kinit -k -t ./dev.keytab dev@TEST.ELASTIC.CO 

zip krb-bundle.zip es.keytab krb5.conf
