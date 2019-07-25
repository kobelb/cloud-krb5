#! /bin/bash

set -e

# Build the container
docker build -t kdc ./

# Start the container up
docker run -d -p 88:88 -p 88:88/udp --name kdc kdc:latest

# Copy the keytabs we need
docker cp kdc:/root/es.keytab ./
docker cp kdc:/root/dev.keytab ./

# Get the ticket-granting-ticket for the dev user
kinit -k -t ./dev.keytab dev@TEST.ELASTIC.CO 

zip krb-bundle.zip es.keytab krb5.conf
