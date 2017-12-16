#!/usr/bin/env bash

. ../lib.sh
count=0
log_every=100
bytes_written=0


if [ "$TESTFILESAPI" = true ]
then
  ipfs files mkdir /narinfo
fi

for f in $(ls $DATADIR/d/*.narinfo | sort -R | tail -n $1)
do
  if [ "$TESTFILESAPI" = true ]
  then
    hashname=$(ipfs --local add -q $f)
    sleep 1
    ipfs files cp /ipfs/$hashname /narinfo/$hashname
    ipfs files flush /
  else
    ipfs --local add --raw-leaves $f > /dev/null 2>&1
  fi
  count=$((count + 1))
  bytes_written=$(($bytes_written + $(du -b $f | awk -F ' ' '{ print $1 }')))
  if (($count % log_every == 0))
  then
    ipfs_calculate_repo_size
    echo "$count,$bytes_written,$IPFS_REPO_SIZE"
  fi
done
