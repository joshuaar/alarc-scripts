#!/usr/bin/python
import sys,os,csv

allfiles = os.listdir(".")
results = [i for i in allfiles if i.endswith("genes.results")]

resultreads = [zip(*[j for j in csv.reader(open(i),delimiter="\t")]) for i in results]
resultcomps = resultreads[0][0][1:]
resultvals = [i[6][1:] for i in resultreads]
resultheaders = ["ID"]+results

table = [resultcomps] + resultvals
table = zip(*table)

table = [resultheaders] + table

wtr = csv.writer(open("all.genes.results.csv","w"))
wtr.writerows(table)
print("Finished writing rows")
