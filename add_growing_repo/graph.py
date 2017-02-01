import matplotlib
import sys

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pylab

plt.style.use("seaborn-whitegrid")

steps, NUMFILES, FILESIZEKB = sys.argv[1:]
tarr, marr = pylab.hsplit(pylab.loadtxt("outdata"), 2)
datapoints = len(tarr)

print("number of datapoints " + str(datapoints))
xarray = pylab.arange(int(steps))
pylab.plot(xarray, tarr)

pylab.xlabel("number of iterations")
pylab.ylabel("elapsed time (s)")
pylab.title("each add size: " + str(int(NUMFILES) * int(FILESIZEKB) / 1000) + "MB")
pylab.savefig("outdata.png")
pylab.clf()

pylab.plot(xarray, marr)
pylab.xlabel("number of files")
pylab.ylabel("maximum resident size (KB)")
pylab.savefig("memory.png")
