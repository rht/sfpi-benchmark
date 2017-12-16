DEFAULT_SEED=42
DATADIR=../data
SPEC_NOSYNC=$(cat ../add/spec-nosync)

ipfs_nosync() {
    ipfs config --json Datastore.Spec "$SPEC_NOSYNC" 2>/dev/null
}

ipfs_reset() {
    rm -rf ~/.ipfs
    ipfs init -e >/dev/null
    ipfs_nosync
}

ipfs_calculate_repo_size() {
    IPFS_REPO_SIZE=$(du -b ~/.ipfs/blocks | tail -n 1 | awk -F ' ' '{ print $1 }')
}

random() {
    $GOPATH/src/github.com/ipfs/go-ipfs/test/sharness/bin/random "$@" $SEED
}

random_files() {
    $GOPATH/src/github.com/ipfs/go-ipfs/test/sharness/bin/random-files "$@" -seed $SEED
}

inc_seed() {
  SEED=$((SEED + 1))
}

#wrapper for a customized `time` command
TIME() {
    command time -f '%e %M' $*
}

# boilerplate steps for each benchmark

# make sure nosync is enabled
ipfs_nosync

# prepare data
mkdir -p $DATADIR/d
if [ "$(ls -A $DATADIR/d)" ]
then
  :
else
  tar xf $DATADIR/narinfo.tar.gz -C $DATADIR/d
fi
