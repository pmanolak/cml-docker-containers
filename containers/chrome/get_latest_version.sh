#!/bin/bash

# fetch the packages file
url="https://dl.google.com/linux/chrome/deb/dists/stable/main/binary-amd64/Packages"
curl -s "$url" |

  # extract 'Package:' and the next 'Version:'
  awk '/^Package: google-chrome-stable$/,/^$/ {
    if ($1 == "Version:") print $2
  }' |

  # sort with version sort and get the latest (last line)
  sort -V | tail -n1
