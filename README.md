# sfpi-benchmark

Run `make` to build.  
TODO: this should be structured just like the sharness test  
dependencies: go-ipfs, curl, rrdtool, jq, python3

#add

Add performance of many small files on ipfs, compared to various tools.  
data: 10 kb each of files up to 3000 files
![](add/outdata.png)

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
