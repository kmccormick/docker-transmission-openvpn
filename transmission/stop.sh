#! /bin/sh

# only 15 characters available to match
sudo /usr/bin/pkill -x transmission-da

# Let transmission-daemon exit cleanly
# transmission-daemon goes defunct rather than dying
# watch for the cmdline to change before completing
echo Waiting for transmission-daemon to cleanup
while pgrep -f "transmission-daemon -g .* --foreground" >/dev/null ; do
	sleep 0.2
done
