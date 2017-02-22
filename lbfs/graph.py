#!/usr/bin/env python3

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pylab

plt.style.use("seaborn-whitegrid")

fig, ax = plt.subplots()

# git and ipfs
tarr, marr = pylab.loadtxt("outdata").T
tools, size = pylab.genfromtxt("size", dtype=str, delimiter=" ").T
sizemb = size.astype(int) / 1024 / 1024

# targz, tarxz, tarbz2
for ar_type in ["emacss.tar.gz", "emacss.tar.xz", "emacss.tar.bz2"]:
    tt, mm = pylab.loadtxt(ar_type + "-output").T
    t = sum(tt)
    m = sum(mm) / len(mm)
    sz = sum(pylab.loadtxt(ar_type + "-size")) / 1024 / 1024
    tarr = pylab.append(tarr, t)
    marr = pylab.append(marr, m)
    sizemb = pylab.append(sizemb, sz)
    tools = pylab.append(tools, ar_type.replace("emacss.", ""))


ax.scatter(sizemb, tarr)
for i, txt in enumerate(tools):
    ax.annotate(txt, (sizemb[i], tarr[i]))

pylab.xlabel("archive size (MB)")
pylab.ylabel("elapsed time (s)")
pylab.savefig("outdata.png")
