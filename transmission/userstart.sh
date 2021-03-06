#!/bin/sh

# Source our persisted env variables from container startup
. /etc/transmission/environment-variables.sh

tun0ip="$1"
echo "Updating TRANSMISSION_BIND_ADDRESS_IPV4 to tun0 ip: ${tun0ip}"
export TRANSMISSION_BIND_ADDRESS_IPV4=${tun0ip}

echo "Generating transmission settings.json from env variables"
dockerize -template /etc/transmission/settings.tmpl:${TRANSMISSION_HOME}/settings.json /bin/true

if [ ! -e "/dev/random" ]; then
  # Avoid "Fatal: no entropy gathering module detected" error
  echo "INFO: /dev/random not found - symlink to /dev/urandom"
  ln -s /dev/urandom /dev/random
fi

echo "STARTING TRANSMISSION"
exec /usr/bin/transmission-daemon -g ${TRANSMISSION_HOME} --foreground &

if [ "$OPENVPN_PROVIDER" = "PIA" ]
then
    echo "STARTING PORT UPDATER"
    exec /etc/transmission/periodicUpdates.sh &
else
    echo "NO PORT UPDATER FOR THIS PROVIDER"
fi

echo "Transmission startup script complete."
