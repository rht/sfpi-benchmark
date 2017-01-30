DEFAULT_SEED=42

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
