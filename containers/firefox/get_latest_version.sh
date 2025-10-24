#!/bin/bash

# fetch the packages file
url="https://packages.mozilla.org/apt/dists/mozilla/main/binary-amd64/Packages"
curl -s "$url" |

  # extract 'Package:' and the next 'Version:'
  awk '/^Package: firefox$/,/^$/ {
    if ($1 == "Version:") print $2
  }' |

  # sort with version sort and get the latest (last line)
  sort -V | tail -n1
