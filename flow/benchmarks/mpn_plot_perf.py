

print("Running performance analysis...")
print("Out dir     : %s" % out_dir)
print("Architecture: %s" % arch)

import os
import sys
import csv

csv_records = []
csv_path    = os.path.join(out_dir,"mpn-performance-%s.csv" % arch)

for record in performance:
    func, lx,ly,instr_s,instr_e,cycle_s,cycle_e = record

    cycles = cycle_e - cycle_s
    instrs = instr_e - instr_s

    csv_records.append (
        [arch, func, lx, ly, cycles, instrs]
    )

with open(csv_path, 'w') as fh:
    
    writer = csv.writer(fh, delimiter = ',',quotechar="\"")

    for row in csv_records:
        writer.writerow(row)

print("Written results to %s" % csv_path)

