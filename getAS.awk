#!/bin/awk -f
BEGIN{FPAT="([^,]+)|(\"[^\"]+\")"; OFS="\t"} 
$2~/AS[0-9]/ {gsub(/[^A-Z]/,"", $4); print $2, $3, substr($4, 0, 2), $5, $6 }
/vsc-initialized/ {exit}
