#!/bin/bash

mkdir -p data/bridges-added-by-date/"$(date +%Y)/$(date +%m)/$(date +%d)"

echo '| Nickname |  Contact | Hashed Fingerprint	| Running | Flags | Last Seen | First Seen | Last Restarted | Advertised Bandwidth | Platform | Version | Version Status | Recommended Version | BridgeDB Distributor | OR Addresses | Transports | BlockList |' > data/bridges-added-by-date/"$(date +%Y)/$(date +%m)/$(date +%d)"/Readme.md
echo '|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|' >> data/bridges-added-by-date/"$(date +%Y)/$(date +%m)/$(date +%d)"/Readme.md

TODAY=$(date +%F) # gets YYYY-MM-DD

curl -s "https://onionoo.torproject.org/details" | jq -r --arg TODAY "$TODAY" '
  .bridges[]
  | select((.first_seen // "") | startswith($TODAY))
  | [
      (.nickname // "N/A"),
      (.contact // "N/A"),
      (.hashed_fingerprint // "N/A"),
      (.running | tostring),
      ((.flags // []) | join(", ")),
      (.last_seen // "N/A"),
      (.first_seen // "N/A"),
      (.last_restarted // "N/A"),
      ((.advertised_bandwidth // 0) | tostring),
      (.platform // "N/A"),
      (.version // "N/A"),
      (.version_status // "N/A"),
      ((.recommended_version // false) | tostring),
      (.bridgedb_distributor // "N/A"),
      ((.or_addresses // []) | join(", ")),
      ((.transports // []) | join(", ")),
      ((.blocklist // []) | join(", "))
    ]
  | map(tostring | gsub("\\|"; "\\|") | gsub("\\\\"; "\\\\"))
  | join(" | ")
  | "|" + . + "|"
' >> data/bridges-added-by-date/"$(date +%Y)/$(date +%m)/$(date +%d)"/Readme.md
