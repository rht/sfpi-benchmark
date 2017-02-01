#! /usr/bin/env python3

import matplotlib
matplotlib.use("Agg")

import matplotlib.pyplot as plt
from numpy import genfromtxt
import argparse

plt.style.use("seaborn-whitegrid")


def byte_to_megabyte(x):
    return (x / (1024 * 1024)).astype(int)


def graph_ipfs(data, output):
    # data is [ [filecount, data_disk, data_repo] ]
    fig = plt.figure()
    ax1 = fig.add_subplot(111)

    data_added = ax1.plot(data['fc'], byte_to_megabyte(data['dd']), 'r', label="Data added")
    repo_size  = ax1.plot(data['fc'], byte_to_megabyte(data['dr']), 'b', label="IPFS repo size")
    ax1.legend(loc='best')
    ax1.set_ylabel('Size in MiB')
    ax1.set_xlabel('Files added')

    plt.savefig(output)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--csv', required=True, type=str)
    parser.add_argument('--output', required=True, type=str)
    args = parser.parse_args()
    data = genfromtxt(args.csv, delimiter=',', names=['fc', 'dd', 'dr'])
    graph_ipfs(data, args.output)
