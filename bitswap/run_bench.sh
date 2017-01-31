#!/bin/sh

ipfs daemon &
PID_DAEMON=$!

sleep 10

mkdir -p data
./ipfs-collect &
PID_COLLECT=$!

cleanup() {
    echo "cleaning up"
    kill -9 $PID_COLLECT
    killall -9 ipfs-collect
    #kill -9 $PID_DAEMON
}

trap "cleanup; exit" SIGHUP SIGINT SIGTERM

echo "ipfs get"
ipfs get -o data Qme6epvZDj3vzHcFKdF1nZhbixjw8Bn4imGcKnbUyBJL89

cleanup
sleep 5

echo "plotting graph"
./ipfs-graph

#cleanup
rm -r data
rm ipfs.rrd
