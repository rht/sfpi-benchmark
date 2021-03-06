all: add/outdata.png repo_size/graph_10k.png repo_size/graph_10k_filesapi.png add_growing_repo/outdata.png
#all: add/outdata.png bitswap/ipfs.png repo_size/graph_10k.png repo_size/graph_10k_filesapi.png add_growing_repo/outdata.png

add/outdata.png:
	set -e ;\
	cd add ;\
	./perf.sh

add_growing_repo/outdata.pngj:
	set -e ;\
	cd add_growing_repo ;\
	./benchmark.sh

bitswap/ipfs.png:
	set -e ;\
	cd bitswap ;\
	./run_bench.sh

repo_size/graph_10k.png:
	set -e ;\
	cd repo_size ;\
	./benchmark.sh 10000 | tee 10k_log.csv ;\
	./graph.py --csv 10k_log.csv --output graph_10k.png

repo_size/graph_10k_filesapi.png:
	set -e ;\
	cd repo_size ;\
	TESTFILESAPI=true ./benchmark.sh 10000 | tee 10k_log_filesapi.csv ;\
	./graph.py --csv 10k_log_filesapi.csv --output graph_10k_filesapi.png

clean:
	-rm add/outdata.png
	-rm bitswap/ipfs.png
	-rm repo_size/graph_10k.png
