#!/usr/bin/env bash
count=0
log_every=100
bytes_written=0

. ../lib.sh

mkdir -p d
if [ "$(ls -A d)" ]
then
  :
else
  tar xf narinfo.tar.gz -C d/
fi

for f in $(ls d/*.narinfo | sort -R | tail -n $1)
do
  ipfs --local add --raw-leaves $f > /dev/null 2>&1
  count=$((count + 1))
  bytes_written=$(($bytes_written + $(du -b $f | awk -F ' ' '{ print $1 }')))
  if (($count % log_every == 0))
  then
    echo "$count,$bytes_written,$(du -b ~/.ipfs/blocks | tail -n 1 | awk -F ' ' '{ print $1 }')"
  fi
done
