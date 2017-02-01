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

#ipfs files mkdir /narinfo
for f in $(ls $DATADIR/d/*.narinfo | sort -R | tail -n $1)
do
  if [ "$TESTFILESAPI" = true ]
  then
    hashname=$(ipfs --local add -q $f)
    sleep 1
    ipfs files cp /ipfs/$hashname /narinfo/$hashname
  else
    ipfs --local add --raw-leaves $f > /dev/null 2>&1
  fi
  count=$((count + 1))
  bytes_written=$(($bytes_written + $(du -b $f | awk -F ' ' '{ print $1 }')))
  if (($count % log_every == 0))
  then
    echo "$count,$bytes_written,$(du -b ~/.ipfs/blocks | tail -n 1 | awk -F ' ' '{ print $1 }')"
  fi
done
