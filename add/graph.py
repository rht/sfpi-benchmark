import matplotlib
import sys

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pylab

plt.style.use("seaborn-whitegrid")

NFILES, TOOLS, step, FILESIZEKB = sys.argv[1:]
TOOLS = TOOLS.split(',')
ntools = len(TOOLS)
tarr, marr = pylab.hsplit(pylab.loadtxt("outdata"), 2)
l = len(tarr)
datapoints = int(l / ntools)
tarr = tarr.reshape((datapoints, ntools)).T
marr = marr.reshape((datapoints, ntools)).T
print("number of datapoints " + str(datapoints))
xarray = pylab.arange(50, int(NFILES), int(step))
for x in tarr:
    pylab.plot(xarray, x)
pylab.xlabel("number of files")
pylab.ylabel("elapsed time (s)")
pylab.legend(TOOLS, loc="upper center", ncol=3)
pylab.title("each size: " + FILESIZEKB + "kb")
pylab.savefig("outdata.png")
pylab.clf()

#throughputs = xarray / tarr * FILESIZEKB
#for x in throughputs:
#    pylab.plot(xarray, x)
#pylab.xlabel("number of files")
#pylab.ylabel("write throughput (KB/s)")
#pylab.legend(TOOLS, loc="upper center", ncol=3)
#pylab.savefig("throughput_outdata.png")
#pylab.clf()

for x in marr:
    pylab.plot(xarray, x)
pylab.xlabel("number of files")
pylab.ylabel("maximum resident size (KB)")
pylab.legend(TOOLS, loc="upper center", ncol=3)
pylab.savefig("memory.png")
