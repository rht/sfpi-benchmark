#!/bin/sh

ipfs daemon &
PID_DAEMON=$!

sleep 10

touch data
./ipfs-collect &
PID_COLLECT=$!

cleanup() {
    echo "cleaning up"
    kill -9 $PID_COLLECT
    kill -9 $PID_DAEMON
}

trap "cleanup; exit" SIGHUP SIGINT SIGTERM

echo "ipfs get"
ipfs get -o data QmPVP4sDre9rtYahGvcjv3Fqet3oQyqrH5xS33d4YBVFme


cleanup
sleep 5

echo "plotting graph"
./ipfs-graph

#cleanup
rm -r data
rm ipfs.rrd
