./stats.awk apnic.txt country-codes.tsv ips_asnlookup.txt | sort -n -t$'\t' -k3,3 | column -t -s$'\t'
