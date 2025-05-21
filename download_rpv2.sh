#!/bin/bash

CC_SNAPSHOT="2023-06"
LANG="en"
PARTITION="head_middle"
BASE_URL="https://data.together.xyz/redpajama-data-v2/v1.0.0"

listings_tag="${LANG}-${CC_SNAPSHOT}-${PARTITION}"
mkdir -p rpv2
mkdir -p rpv2/documents # Create base documents directory upfront

echo "Downloading listings file..."
wget "${BASE_URL}/listings/${listings_tag}.txt" -O "rpv2/${listings_tag}.txt"
listings_file="rpv2/${listings_tag}.txt"

if [ ! -f "$listings_file" ]; then
    echo "Error: Listings file '$listings_file' not found or failed to download."
    exit 1
fi

echo "Downloading the first 5 documents..."
# Process only the first 5 lines from the listings file
head -n 5 "$listings_file" | while read line; do
  # Skip empty lines, if any
  if [ -z "$line" ]; then
    echo "Skipping empty line in listings file."
    continue
  fi

  url="${BASE_URL}/documents/${line}.json.gz"
  dest="rpv2/documents/${line}.json.gz"

  echo "Preparing to download: $url to $dest"
  mkdir -p $(dirname $dest)

  if wget "$url" -O "$dest"; then
    echo "Successfully downloaded $dest"
  else
    echo "Failed to download $url - Check URL or network."
    # Optionally, you might want to remove the partially downloaded file or empty file
    # rm -f "$dest"
  fi
done

echo "Finished processing the first 5 documents (or fewer if the list was shorter)."
