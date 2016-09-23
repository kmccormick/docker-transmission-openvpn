#!/bin/sh
# Get DOCKER_TRANSMISSION_USER from environment
. /etc/transmission/environment-variables.sh
# Make sure DOCKER_TRANSMISSION_USER can use client id
touch /etc/transmission/pia_client_id
chown $DOCKER_TRANSMISSION_USER: /etc/transmission/pia_client_id
# Ensure TRANSMISSION_HOME is created and writable
mkdir -p ${TRANSMISSION_HOME}
chown ${DOCKER_TRANSMISSION_USER} ${TRANSMISSION_HOME}
# Run standard start script as DOCKER_TRANSMISSION_USER
exec su - $DOCKER_TRANSMISSION_USER -c "/etc/transmission/userstart.sh $4"
