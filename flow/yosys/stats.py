#! /usr/bin/python3

"""
A simple script which looks for stats from the formal proof
reports.
"""

import os
import sys


def getProofTimes(files):
    """
    Take a list of proof report file paths and extract
    pass status and runtime from them.
    Return a list of tuples.
    """
    
    prooftimes = []

    for f in files:

        with open(f,"r") as fh:
            lines = fh.readlines()
            
            p = [l for l in lines if "Status:" in l]

            if len(p) >= 1:
                t,x,s = p[0].lstrip("# ").partition(" ")

                h,m,s = t.split(":")
            
                passed = "PASSED" in p[0]
                
                time  = int(s) + 60*int(m) + 3600*int(h)
                fname = os.path.basename(f).partition(".")[0]

                prooftimes.append((passed,fname,time))

    return prooftimes

def main():
    inputFiles = sys.argv[1:]
    prooftimes = getProofTimes(inputFiles)
    
    for p in prooftimes:
        passed, proof, secs = p
        print("%s, %s, %d" %(passed,proof,secs))

if(__name__ == "__main__"):
    main()
