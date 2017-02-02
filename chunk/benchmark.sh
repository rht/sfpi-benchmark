#!/usr/bin/env bash

. ../lib.sh

NAME=pdb
#NAME=rfc
#NAME=d
DATA=$DATADIR/$NAME

disk_size() {
    echo $(du -b $1 | tail -n 1 | awk -F ' ' '{ print $1 }')
}

ipfschunk() {
    TIME ipfs add --local -q -r -p=false -s $1 $DATA > /dev/null
    ipfs_calculate_repo_size
    echo "$1 $IPFS_REPO_SIZE" >>size
    ipfs_reset
}

ipfstargz() {
    TIME tar czf $NAME.tar.gz -P $DATA && ipfs add --local -q -p=false $NAME.tar.gz > /dev/null
    ipfs_calculate_repo_size
    echo "$1 $IPFS_REPO_SIZE" >>size
    ipfs_reset
    rm $NAME.tar.gz
}

tarutil() {
    fname=$2
    TIME tar $1 $fname -P $DATA
    echo "$3 $(disk_size $fname)" >>size
    rm $fname
}

targz() {
    tarutil cfz $NAME.tar.gz targz
}

tarxz() {
    tarutil cfJ $NAME.tar.xz tarxz
}

tarbz2() {
    tarutil cfj $NAME.tar.bz2 tarbz2
}

7zip() {
    TIME 7z a $NAME.7z $DATA -y
    echo "7zip $(disk_size $NAME.7z)" >>size
    rm $NAME.7z
}

gitpackfile() {
    savedWD=$PWD
    cd /tmp
    mkdir -p repo
    cd repo
    cp -r $savedWD/$DATA data
    git init -q
    TIME git add data
    #echo "git-objects $(($(git count-objects  | awk '{ print $3 }')*1024))" >>$savedWD/size
    echo "git-objects $(disk_size .git/objects)" >>$savedWD/size
    cd ..
    rm -rf repo
    cd $savedWD
}

# run chunking benchmark
echo -n "" >outdata
echo -n "" >size

targz 2>>outdata
tarxz 2>>outdata
tarbz2 2>>outdata
7zip 2>>outdata
gitpackfile 2>>outdata
ipfstargz ipfstargz 2>>outdata
ipfschunk size-262144 2>>outdata # default, 256KB
ipfschunk rabin 2>>outdata
ipfschunk size-10240 2>>outdata # 10 KB
ipfschunk size-1024 2>>outdata # 10 KB

python graph.py
