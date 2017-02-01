#!/usr/bin/env bash

. ../lib.sh

NAME=pdb
#NAME=rfc
DATA=$DATADIR/$NAME

ipfschunk() {
    TIME ipfs add --local -q -r -p=false -s $1 $DATA > /dev/null
    ipfs_calculate_repo_size
    echo "$1 $IPFS_REPO_SIZE" >>size
    ipfs_reset
}

targz() {
    TIME tar czf $NAME.tar.gz -P $DATA
    echo "targz $(du -b $NAME.tar.gz | tail -n 1 | awk -F ' ' '{ print $1 }')" >>size
    rm $NAME.tar.gz
}

tarbz2() {
    TIME tar cjf $NAME.tar.bz2 -P $DATA
    echo "tarbz2 $(du -b $NAME.tar.bz2 | tail -n 1 | awk -F ' ' '{ print $1 }')" >>size
    rm $NAME.tar.bz2
}

7zip() {
    TIME 7z a $NAME.7z $DATA -y
    echo "7zip $(du -b $NAME.7z | tail -n 1 | awk -F ' ' '{ print $1 }')" >>size
    rm $NAME.7z
}


# run chunking benchmark
echo -n "" >outdata
echo -n "" >size

targz 2>>outdata
tarbz2 2>>outdata
7zip 2>>outdata

# ipfs
ipfschunk size-262144 2>>outdata # default, 256KB chunk size
ipfschunk rabin 2>>outdata
#ipfschunk size-1024 2>>outdata # 1 KB
ipfschunk size-10240 2>>outdata # 10 KB

python graph.py
