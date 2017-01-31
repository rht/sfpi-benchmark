Benchmark IPFS with realworld data
==================================

Extract the `test_data.tar.gz` and execute like this:
```
./benchmark.sh 10000 | tee 10k_log.csv
```

This will add 10000 random `.narinfo` files from the current
directory and log in the format

```
filecount,size_disk,size_repo
```

You can then graph the result using graph.py:

./graph.py --csv 10k_log.csv

and then ponder about exponential growth with limited
resources.
