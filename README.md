# Censored Planet AS
A collection of scripts that were useful to me in doing AS coverage analysis and selection.

The requirements at a high level for these scripts are a UNIX system, Python, and Nim (which in turn depends on a C compiler like GCC). All of the commands outlined here write to stdout, redirect them to a file or to `less` to save and view the data.

## Fetching APNIC Data

```
curl -s https://stats.labs.apnic.net/aspop | ./apnic.awk | tr -d '\"'
```
First part fetches the HTML webpage from APNIC, second part filters out the data we want, and the third part removes some double quotes that are in the data. To do this more robustly you could try and track down their API, or HTML and JSON parsing.

## Fetching ASRank Data

We use the asrank-download.py script provided from https://api.asrank.caida.org/v2/docs. You will likely need to do a `pip install graphqlclient` to get the GraphQL client library that the script uses.

```
python asrank-download.py -a asns.json
./asrank.awk asns.json
```
The Python script does take a while to run, as it is fetching all of the AS data.


## Fetching PeeringDB data
I cannot remember exactly where I pulled this data from, all I know is that it probably came from https://www.peeringdb.com/apidocs/. You'll want to marshall this into a list of domains. Then, on a worker, run the following:
```
cat domains.txt | zdns alookup -result-verbosity short --name-servers=1.1.1.1 > output.json
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' output.json | sort -u > ips.tx
```
The first uses zdns to grab all of the domains line by line in `domains.txt`, while the second command grabs just the IP addresses and remove duplicates.


# Getting Estimated Coverage from APNIC with a list of IPs

For this, you'll need [Nim 1.6](https://nim-lang.org/install.html). Run `nimble install https://github.com/z-------------/nim-mmdb` to get the MMDB file reader. Also, make sure you have GeoLite2-Country.mmdb and GeoLite2-ASN.mmdb in the same directory as the `main.nim` file. Run `nim c -d:release main.nim` to generate the `main` executable. This takes IP addresses from the arguments and prints out the AS + country code for the IP if it is found.

To see the coverage from a list of IPs, do the following:
```
cat ips.txt | xargs ./main | ./stats.awk apnic.txt country-codes.tsv - | sort -n -t$'\t' -k3,3 | column -t -s$'\t'
```
First bit takes the list of IPs, second runs each IP against `main` to get a list of AS + country pairs, `stats.awk` does the actual summing and math to figure out what the breakdown looks like per country. The last two bits sort based on the percent of country covered. Finally, we use `column` to help pretty print everything. I reccomend piping this into `less` if you want to explore the data. 

While it would have been pretty doable to bundle this all into a standalone Nim program, it wouldn't be as reusable. The context for this development process was that I was doing a lot of adhoc queries and using many different data sources. In that regard, the shell was my best friend for processing tons of data without writing specific programs. Now that the data and process are fixed, converting this to a standalone program (in Go) should be pretty straightforward.
