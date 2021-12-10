#!/bin/awk -f
BEGIN{OFS="\t"}
match($0, /asn": "([0-9]*)",/, asNum){}
match($0, /asnName": "(.*)", "rank"/, asName){}
match($0, /numberAsns": ([0-9]*),/, numberAsns){}
match($0, /iso": "(.*)",/, iso){}
NR==FNR && byCountry[iso[1]] < 10 {byCountry[iso[1]]++}
NR!=FNR && rank[iso[1]] < 10 {
    rank[iso[1]]++
    percent = 100 / byCountry[iso[1]]
    print "AS" asNum[1], asName[1], iso[1], numberAsns[1], percent
}
