#!/usr/bin/env bash
count=0
log_every=100
bytes_written=0

. ../lib.sh
DATADIR=../data

mkdir -p $DATADIR/d
if [ "$(ls -A $DATADIR/d)" ]
then
  :
else
  tar xf $DATADIR/narinfo.tar.gz -C $DATADIR/d
fi

for f in $(ls $DATADIR/d/*.narinfo | sort -R | tail -n $1)
do
  ipfs --local add --raw-leaves $f > /dev/null 2>&1
  count=$((count + 1))
  bytes_written=$(($bytes_written + $(du -b $f | awk -F ' ' '{ print $1 }')))
  if (($count % log_every == 0))
  then
    echo "$count,$bytes_written,$(du -b ~/.ipfs/blocks | tail -n 1 | awk -F ' ' '{ print $1 }')"
  fi
done
