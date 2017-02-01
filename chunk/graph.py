#!/usr/bin/env python3

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pylab

plt.style.use("seaborn-whitegrid")

fig, ax = plt.subplots()

tarr, marr = pylab.loadtxt("outdata").T
tools, size = pylab.genfromtxt("size", dtype=str, delimiter=" ").T
sizemb = size.astype(int) / 1024 / 1024

ax.scatter(sizemb, tarr)
for i, txt in enumerate(tools):
    ax.annotate(txt, (sizemb[i], tarr[i]))

pylab.xlabel("archive size (MB)")
pylab.ylabel("elapsed time (s)")
pylab.savefig("outdata.png")
