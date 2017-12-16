#!/usr/bin/env bash

. ../lib.sh

NAME=emacss
#declare -a emacsArr=(emacs-20.1 emacs-20.2 emacs-20.3 emacs-20.4 emacs-24.4 emacs-24.5)
declare -a emacsArr=(emacs-20.1 emacs-20.2 emacs-20.3)
#NAME=pdb
#NAME=rfc
#NAME=d
DATA=$DATADIR/$NAME

disk_size() {
    echo $(du -b $1 | tail -n 1 | awk -F ' ' '{ print $1 }')
}

ipfschunk() {
    echo $1
    (TIME ipfs add --local -q --silent -r -p=false -s $1 $DATA 1> /dev/null) 2>> outdata
    ipfs_calculate_repo_size
    echo "$1 $IPFS_REPO_SIZE" >>size
    ipfs_reset
}

ipfstargz() {
    echo ipfstargz
    (TIME tar czf $NAME.tar.gz -P $DATA && ipfs add --local -q --silent -p=false $NAME.tar.gz 1> /dev/null) 2>> outdata
    ipfs_calculate_repo_size
    echo "$1 $IPFS_REPO_SIZE" >>size
    ipfs_reset
    rm $NAME.tar.gz
}

tarutil() {
    fname=$2
    echo -n "" >$fname-output
    echo -n "" >$fname-size
    for emacsEach in "${emacsArr[@]}"; do
        (TIME tar $1 $emacsEach-$fname -P $DATA/$emacsEach) 2>> $fname-output
        echo "$(disk_size $emacsEach-$fname)" >> $fname-size
        rm $emacsEach-$fname
    done
}

targz() {
    tarutil cfz $NAME.tar.gz
}

tarxz() {
    tarutil cfJ $NAME.tar.xz
}

tarbz2() {
    tarutil cfj $NAME.tar.bz2
}

7zip() {
    echo -n "" >7z-output
    echo -n "" >7z-size
    for emacsEach in "${emacsArr[@]}"; do
        (TIME 7z a $emacsEach.7z $DATA/$emacsEach -y) 2>> 7z-output
        echo "$(disk_size $emacsEach.7z)" >> 7z-size
        rm $emacsEach.7z
    done
}

gitpackfile() {
    savedWD=$PWD
    cd /tmp
    mkdir -p repo
    cd repo
    cp -r $savedWD/$DATA data
    git init -q
    git config core.safecrlf false
    (TIME git add data > /dev/null) 2>> $savedWD/outdata
    #echo "git-objects $(($(git count-objects  | awk '{ print $3 }')*1024))" >>$savedWD/size
    echo "git-objects $(disk_size .git/objects)" >>$savedWD/size
    cd ..
    rm -rf repo
    cd $savedWD
}

# run chunking benchmark
echo -n "" >outdata
echo -n "" >size

targz
tarxz
tarbz2
7zip
gitpackfile
ipfstargz ipfstargz
ipfschunk size-262144 # default, 256KB
ipfschunk rabin
ipfschunk size-10240 # 10 KB
#ipfschunk size-4000 # 10 KB
#
python graph.py
