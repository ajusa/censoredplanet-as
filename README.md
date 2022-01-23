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
