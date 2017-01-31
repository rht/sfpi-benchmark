# sfpi-benchmark

USAGE: run `make` to build graph, `make clean && make` to rerun the benchmark  
TODO: this should be structured just like the sharness test  
dependencies: go-ipfs, curl, rrdtool, jq, python3, matplotlib, numpy

#add

Add performance of many small files on ipfs, compared to various tools.  
data: 10 kb each of files up to 3000 files
![](add/outdata.png)

#go-ipfs binary size

TODO: automatically generate this report
```shell
$ du -b $f | awk -F ' ' '{ print $1 }'
```
24 MB on 'go-ipfs version: 0.4.5-pre2-'

#bitswap

- A more compact version of https://github.com/ion1/ipfs-benchmark (@ion1)  

![](bitswap/ipfs.png)

#gc

- https://github.com/ipfs/go-ipfs/issues/3462 (@kevina)

#memory

Memory consumption of `ipfs add` compared to various tools
data: 10 kb each of files up to 3000 files
![](add/memory.png)

#repo size after pinned add
- https://github.com/ipfs/go-ipfs/issues/3621, https://ipfs.io/ipfs/QmcsrSRuBmxNxcEXjMZ1pmyRgnutCGwfAhhnRfaNn9P94F (@mguentner)

![](repo_size/graph_10k.png)
