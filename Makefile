all: add/outdata.png bitswap/ipfs.png

add/outdata.png:
	set -e ;\
	cd add ;\
	./perf.sh

bitswap/ipfs.png:
	set -e ;\
	cd bitswap ;\
	./run_bench.sh
