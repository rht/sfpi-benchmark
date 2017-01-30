#ref https://gist.github.com/kevina/63efcab752d1a15e2fde6651b76d2a80

export IPFS_PATH=/aux/scratch/ipfs
EXTRA_ARGS="--raw-leaves"
. lib.sh

SEED=$DEFAULT_SEED

set -e

if [ -e d ]; then
    echo 'Directory "d/" exists.  Please remove it first'
    exit 1
fi


add_pinned_file() {
    inc_seed
    random 4000 > afile
    ipfs add $EXTRA_ARGS --pin=true afile > /dev/null
    rm afile
}

for i in $(seq 1 1000); do
  echo "Adding $i/1000 file"
  add_pinned_file
done

SEED=0

add_small_dir() {
  inc_seed
  echo "Creating Small Dir: seed=$SEED"
  random_files -q -dirs 4 -files 35 -depth 5 -random-fanout -random-size d
  echo "Adding Small Dir: pinned=$1"
  /usr/bin/time ipfs add $EXTRA_ARGS --pin=$1 -r d > /dev/null
  rm -r d
}

for i in $(seq 1 100); do
  add_small_dir true
  add_small_dir false
done

add_med_dir() {
  inc_seed
  echo "Creating Medium Dir: seed=$SEED"
  random_files -q -dirs 4 -files 100 -depth 7 -random-fanout -random-size d
  echo "Adding Medium Dir: pinned=$1"
  /usr/bin/time ipfs add $EXTRA_ARGS --pin=$1 -r d > /dev/null
  rm -r d
}

for i in $(seq 1 10); do
  add_med_dir true
  add_med_dir false
done

add_large_dir() {
  inc_seed
  echo "Creating Large Dir: seed=$SEED"
  random_files -q -dirs 4 -files 100 -depth 10  -random-fanout -random-size d
  du -hs d
  echo "Adding Large Dir: pinned=$1"
  /usr/bin/time ipfs add $EXTRA_ARGS --pin=$1 -r d > /dev/null
  rm -r d
}

SEED=1000

add_large_dir true
add_large_dir false
add_large_dir true
add_large_dir false
