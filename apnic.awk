#!/bin/awk -f
BEGIN{FPAT="([^,]+)|(\"[^\"]+\")"} 
$2~/AS[0-9]/ {gsub(/[^A-Z]/,"", $4); print $2, substr($4, 0, 2), $6 }
/vsc-initialized/ {exit}
