#!/usr/bin/env bash

. ../lib.sh
## PARAMS
FILESIZEKB=10
FILESIZE=$(($FILESIZEKB*1000))
FILESIZEMB=$(($FILESIZEKB/1000))
NUMFILES=1000
steps=500


each() {
    # random-files
    mkdir -p foo
    random-files -q --depth=1 --files="$1" --filesize=$FILESIZE --seed="$2" foo

    # 'ipfs add'
    TIME ipfs add --local -q -p=false -r foo >hashname
    rm hashname

    #cleanup
    rm -r foo
}

benchmark() {
    for i in $(seq 1 $steps)
    do
        each $NUMFILES $(($i*10)) 2>>outdata
        echo $(($i * 100 / $steps))
    done
}

#cleanup ipfs
ipfs_reset

# run add benchmark
echo -n "" >outdata
benchmark

#cleanup ipfs
ipfs_reset

python graph.py $steps $NUMFILES $FILESIZEKB
