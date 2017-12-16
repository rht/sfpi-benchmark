#!/usr/bin/env bash

. ../lib.sh
## PARAMS
TOOLS='random-files,cp,rsync,tar,tar.gz,git,ipfs-flatfs,webtorrent-#-only'

MAXFILESIZEMB=30
MAXFILESIZE=$(($MAXFILESIZEMB*1000000))
FILESIZEKB=10
#FILESIZEKB=500
FILESIZE=$(($FILESIZEKB*1000))
FILESIZEMB=$(($FILESIZEKB/1000))
NFILES=$(($MAXFILESIZE/$FILESIZE))

#steps is the increase step of file numbers
step=$(($NFILES/20))


test_sqlite() {
    for file in foo/*; do
        echo "INSERT INTO files (file) values(x'$(hexdump -ve '1/1 "%0.2X"' $file)');" | sqlite3 files.db 2>&1
    done
}
export -f test_sqlite

export bzzhash="$GOPATH/src/github.com/ethereum/go-ethereum/swarm/cmd/bzzhash/bzzhash"

perf() {
    #1 random-files
    mkdir -p foo
    TIME random-files -q --depth=1 --files="$1" --filesize=$FILESIZE foo  #1KB
    #TIME bash -c "dd_create"

    #2 cp
    mkdir -p bar
    TIME cp -a foo bar
    rm -r bar

    #3 rsync
    mkdir -p bar
    TIME rsync -r foo bar
    rm -r bar

    #4 tar
    TIME tar cf foo.tar foo
    rm foo.tar

    #5 tar gz
    TIME tar czf foo.tar.gz foo
    rm foo.tar.gz

    #6 git
    savedWD=$PWD
    cd /tmp
    mkdir -p gitfoo
    cp -a $savedWD/foo gitfoo/foogit
    cd gitfoo
    git init -q
    TIME git add foogit
    #echo 'git initial commit'
    #time git commit -q -m 'foo'
    cd ..
    rm -rf gitfoo
    cd $savedWD

    #http://stackoverflow.com/questions/10353467/how-to-insert-binary-data-into-sqlite3-database-in-bash
    #echo "create table files (file blob);" | sqlite3 files.db
    #TIME bash -c "test_sqlite"
    #rm files.db

    #mkdir -p darcsfoo
    #cd darcsfoo && cp -r ../foo foodarcs && darcs init -q
    #TIME darcs add -q -r .
    #cd ..
    #rm -r darcsfoo

    #7 'ipfs add'
    #TIME ipfs add -q -r foo >hashname
    #TIME ipfs add -q -r -s rabin foo >hashname
    #TIME ipfs add -q -r -s "size-1024" foo >hashname
    TIME ipfs add -q -p=false -r -s "size-10024" foo >hashname
    #TIME ls -1 foo/* | xargs -I {} ipfs add -q -p=false -s "size-10024" {} >hashname
    #TIME ipfs add -q -r -s "size-262144" foo >hashname  # default block size, 256KB
    #TIME ipfs add -q -r -s "size-2000000" foo >hashname # 20MB
    #ipfs pin rm -r $(cat hashname)
    #ipfs pin rm $(cat hashname)
    rm hashname
    ipfs_reset

    #8 'webtorrent create'
    TIME webtorrent create >webtorrent.out
    rm webtorrent.out

    #9 'bzzhash
    #TIME ls -1 foo/* | xargs -I {} $bzzhash {} >bzzhash.out
    #TIME $bzzhash foo >bzzhash.out
    #rm bzzhash.out

    #9 'jsipfs add'
    #TIME jsipfs files add -q -r foo >hashname
    #rm hashname

    #TIME transmission-create foo
    #rm foo.torrent
    #echo 'ipfs tar add'

    #cleanup
    rm -r foo
}


# run add benchmark
echo -n "" >outdata
for i in $(seq 50 $step $NFILES)
do
    perf $i 2>>outdata
    echo $(($i * 100 / $NFILES))
done

#cleanup ipfs
ipfs_reset

python graph.py $NFILES $TOOLS $step $FILESIZEKB
