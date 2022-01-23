#!/bin/awk -f
BEGIN{
    FS="\t"; OFS="\t"
    fh["AZ"]
    fh["BH"]
    fh["BY"]
    fh["CN"]
    fh["CU"]
    fh["EG"]
    fh["ET"]
    fh["IR"]
    fh["KZ"]
    fh["MM"]
    fh["PK"]
    fh["RU"]
    fh["RW"]
    fh["SA"]
    fh["SD"]
    fh["SY"]
    fh["TH"]
    fh["TR"]
    fh["AE"]
    fh["UZ"]
    fh["VN"]
} 
!x[$0]++ && FNUM == 3 {countries[$2] += total[$2 $1]; total[$2 $1] = 0; work[$2] = work[$2] " " $1}
FNR==1{FNUM++}
FNUM == 1 {total[$3 $1] = $5}
FNUM == 2 {toEnglish[$1] = $2}
END {
    # for (country in fh) print toEnglish[country], country, countries[country]#, work[country]
    for (country in countries) print toEnglish[country], country, countries[country]#, work[country]
}
