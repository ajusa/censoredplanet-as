#!/bin/awk -f
BEGIN{OFS="\t"}
match($0, /asn": "([0-9]*)",/, asNum){}
match($0, /asnName": "(.*)", "rank"/, asName){}
match($0, /numberAsns": ([0-9]*),/, numberAsns){}
match($0, /iso": "(.*)",/, iso){}
{print "AS" asNum[1], numberAsns[1]}
