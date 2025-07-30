#!/bin/bash

echo '| Nickname |  Contact | Hashed Fingerprint	| Running | Flags | Last Seen | First Seen | Last Restarted | Advertised Bandwidth | Platform | Version | Version Status | Recommended Version | BridgeDB Distributor | OR Addresses | Transports | BlockList |' > Readme.md
echo '|---|---|---|---|---|---|---|---|---|---|---|---|---|---|' >> Readme.md

curl -s "https://onionoo.torproject.org/details" | jq -r '
  .bridges[] |
  [
    .nickname,
    .contact,
    .hashed_fingerprint,
    (.running|tostring),
    (.flags | join(", ")),
    .last_seen,
    .first_seen,
    .last_restarted,
    (.advertised_bandwidth | tostring),
    .platform,
    .version,
    .version_status,
    (.recommended_version | tostring),
    (.bridgedb_distributor // "N/A"),
    (.or_addresses | join(", ")),
    .transports,
    .blocklist
  ] |
  map(
    # Escape pipes and backslashes for Markdown compatibility
    gsub("\\|"; "\\|") | gsub("\\\\"; "\\\\")
  ) |
  join(" | ") |
  "|" + . + "|"
' >> Readme.md
