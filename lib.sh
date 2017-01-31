DEFAULT_SEED=42

ipfs_nosync() {
    ipfs config Datastore.NoSync --json 'true' 2>/dev/null
}

ipfs_reset() {
    rm -rf ~/.ipfs
    ipfs init >/dev/null
    ipfs_nosync
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

# make sure nosync is enabled
ipfs_nosync
