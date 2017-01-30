#!/bin/sh

ipfs daemon &
PID_DAEMON=$!

sleep 10

./ipfs-collect &
PID_COLLECT=$!

echo "ipfs get"
ipfs get -o data QmctngrQAt9fjpQUZr7Bx3BsXUcif52eZGTizWhvcShsjz

echo "cleaning up"
kill -9 $PID_COLLECT
kill -9 $PID_DAEMON
sleep 5

echo "plotting graph"
./ipfs-graph
