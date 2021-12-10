from std/importutils import privateAccess
import mmdb, net, streams, os
privateAccess(MMDB)
let countryMemory = readFile("./GeoLite2-Country.mmdb")
let asnMemory = readFile("./GeoLite2-ASN.mmdb")
var countryDb = MMDB()
countryDb.size = countryMemory.len
var asnDb = MMDB()
asnDb.size = asnMemory.len
countryDb.openFile(countryMemory.newStringStream)
asnDb.openFile(asnMemory.newStringStream)
for ip in commandLineParams():
  try:
    var country = countryDb.lookup(ip)
    let asn = asnDb.lookup(ip)
    echo "AS" & $asn["autonomous_system_number"] & "\t" & $country["country"]["iso_code"]
    # echo ip & "\t" & $country["country"]["iso_code"]
  except:
    discard
