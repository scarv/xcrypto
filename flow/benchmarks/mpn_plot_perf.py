

print("Running performance analysis...")

import os
import sys

import matplotlib.pyplot as plt


fig = plt.figure()

colors = {
    "mpn_add" : 'ro',
    "mpn_sub" : 'gx',
    "mpn_mul" : 'b.'
}

for record in performance:
    func, lx,ly,instr_s,instr_e,cycle_s,cycle_e = record

    cycles = cycle_e - cycle_s
    instrs = instr_e - instr_s
    
    plot_c = plt.subplot(1,2,1)
    plt.title("Execution Time (Cycles)")
    plt.plot(lx+ly, cycles, colors[func])
    
    plot_i = plt.subplot(1,2,2)
    plt.title("Instructions Executed")
    plt.plot(lx+ly, instrs, colors[func])

fig.show()
fig.savefig("plot.svg")
