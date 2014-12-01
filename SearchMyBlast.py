from lxml import etree
import argparse
import re
import sys

def parse(input):
	"Parses XML into memory"
	return etree.parse(input)

def getIterationsRoot(input):
	itsRoot = input.xpath("//BlastOutput_iterations")[0]
	return itsRoot

def removeAllIterations(input):
	itsRoot = getIterationsRoot(input)
	its = itsRoot.getchildren()
	[itsRoot.remove(i) for i in its]
	return input

def replaceIterations(input,newIterations):
	removeAllIterations(input)
	itsRoot = getIterationsRoot(input)
	[itsRoot.append(i) for i in newIterations]
	return input

def getIterationQDef(iteration):
	"Gets query description line"
	qdef = iteration.xpath(".//Iteration_query-def")[0]
	return qdef.text

def filterOnQuery(input,regex):
	"Filters on query descrption header"
	itsRoot = getIterationsRoot(input)
	its = itsRoot.getchildren()
	newits = [i for i in its if re.search( regex , getIterationQDef(i) )]
	replaceIterations(input,newits)

def matchesAnIterationHitDef(iteration,regexs):
	"Matches a reges pattern to the hit description line"
	try:
		hdefs = iteration.xpath(".//Hit_def")
	except IndexError:
		return False
	hdefText = [i.text for i in hdefs]
	matchesAll = lambda string,regex: len([i for i in regex if re.search(i,string)]) == len(regex) # returns true if all regexes match a string
	return len([i for i in hdefText if matchesAll(i,regexs)]) > 0

def filterOnHits(input,regexs):
	"Filter on keywords within hits"
	itsRoot = getIterationsRoot(input)
	its = itsRoot.getchildren()
	newits = [i for i in its if matchesAnIterationHitDef(i,regexs)]
	replaceIterations(input,newits)

def MatchesQuerySeqWithHits(iteration,regex):
	"Matches a regex pattern to the query sequence"
	seq = iteration.xpath(".//Hsp_qseq")
	if len(seq) == 0:
		return False
	seq = seq[0].text
	if re.search(regex, seq):
		return True
	else:
		return False
	
def filterOnSeq(input,regex):
	"Filters on query sequence"
	itsRoot = getIterationsRoot(input)	
	its = itsRoot.getchildren()
	newits = [i for i in its if matchesQuerySeqWithHits(i,regex)]
	replaceIterations(input, newits)

def printQueryList(input):
	"Prints a list of query sequences in this blast result"
	itsRoot = getIterationsRoot(input)
	its = itsRoot.getchildren()
	for i in its:
		itstext = i.xpath("./Iteration_query-def")[0]
		itshits = i.xpath(".//Iteration_hits")[0].getchildren()
		if len(itshits) > 0:
			print( itstext.text )

def printReadableList(input):
	"prints a readable list from blast results"
	itsRoot = getIterationsRoot(input)
	its = itsRoot.getchildren()
	qdef = [i.xpath("Iteration_query-def")[0].text for i in its]	
	hitsdef = [[j.text for j in i.xpath(".//Hit_def")] for i in its]
	hitseval = [[j.text for j in i.xpath(".//Hsp_evalue")] for i in its]
	for q,hits,evals in zip(qdef,hitsdef,hitseval):
		print ( q )
		for j,k in zip(hits,evals):
			print ( "\t"+k+"\t"+j )

def printTopHit(input):
	"prints the top hit from each query seq"
	itsRoot = getIterationsRoot(input)
	its = itsRoot.getchildren()
	hitsdef = [[j.text for j in i.xpath(".//Hit_def")] for i in its]
	qdef = [i.xpath("Iteration_query-def")[0].text for i in its]	
	hitseval = [[j.text for j in i.xpath(".//Hsp_evalue")] for i in its]
	for hits,q,e in zip(hitsdef,qdef,hitseval):
		try:
			print( q + "\t" + hits[0] + "\t" + e[0] )
		except IndexError:
			print( "." )
def returnTopHit(input):
	"returns the top hit from each query seq"
	itsRoot = getIterationsRoot(input)
	its = itsRoot.getchildren()
	hitsdef = [[j.text for j in i.xpath(".//Hit_def")] for i in its]
	qdef = [i.xpath("Iteration_query-def")[0].text for i in its]	
	hitseval = [[j.text for j in i.xpath(".//Hsp_evalue")] for i in its]
	out = []
	out.append(["ID","Top_Hit","E_Value"])
	for hits,q,e in zip(hitsdef,qdef,hitseval):
		try:
			out.append([q,  hits[0], e[0]])
		except IndexError:
			out.append([".",".","."])
	return out


def filterOnEVal(input,minval):
	"Filters results based on a minimum e-value"
	evalues = input.xpath("//Hsp_evalue")
	hits = [i.getparent().getparent().getparent() for i in evalues if float(i.text) > minval]
	rm = lambda x: x.getparent().remove(x)
	for i in hits:
		try:
			rm(i)
		except AttributeError:
			pass

def run(args):
	input = etree.parse(args.input[0])
	if args.evalue:
		filterOnEVal(input, args.evalue)
	if args.query:
		filterOnQuery(input, args.query)
	if args.hit:
		filterOnHits(input, args.hit)
	if args.seq:
		filterOnSeq(input, args.seq)
	if args.list:
		printQueryList(input)
	elif args.readable:
		printReadableList(input)
	elif args.tophit:
		printTopHit(input)
	else:
		sys.stdout.write( etree.tostring(input,encoding="UTF-8").decode("utf-8") )
	
if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Search a BLAST XML result for keywords or sequences")
	parser.add_argument("-q", "--query", help="Filter on query description regex")
	parser.add_argument("-e", "--evalue", help="Filter on min E value", type=float)
	parser.add_argument("-t", "--hit", help="Filter on hit discription regex", nargs="+")
	parser.add_argument("-s", "--seq", help="Filter on query sequence regex. Only returns results which have hits and match regex")
	parser.add_argument("input", help="BLAST XML file", nargs=1)
	parser.add_argument("--xml", action="store_true", help="Output results as xml (default)")
	parser.add_argument("--list", action="store_true", help="Output results as list containing all query headers")
	parser.add_argument("--readable", action="store_true", help="Output results as list containing readable hit descriptions")
	parser.add_argument("--tophit", action="store_true", help="Output results as list containing readable hit descriptions")
	args = parser.parse_args()
	run(args)
