all: add/outdata.png bitswap/ipfs.png repo_size/graph_10k.png

add/outdata.png:
	set -e ;\
	cd add ;\
	./perf.sh

bitswap/ipfs.png:
	set -e ;\
	cd bitswap ;\
	./run_bench.sh

repo_size/graph_10k.png:
	set -e ;\
	cd repo_size ;\
	./benchmark.sh 10000 | tee 10k_log.csv ;\
	./graph.py --csv 10k_log.csv
