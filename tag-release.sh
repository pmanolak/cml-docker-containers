#!/bin/bash

if [[ $1 =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  tag=$1
else
  echo "Error: missing or invalid tag (expected format: vMAJOR.MINOR.PATCH)" >&2
  exit 1
fi

# change this if remote is not origin
remote=lwc

git fetch $remote
git tag --list --format='%(refname:short) %(objectname) %(taggerdate) %(describe)'
gh run list --workflow=build.yml

echo -n "enter to continue"
read

id=$(gh run list \
  --workflow=build.yml \
  --json databaseId,status \
  --jq '[.[] | select(.status == "completed")][0].databaseId')

sha=$(gh run view $id --json headSha --jq .headSha)

git tag -sa $tag $sha -m "Release $tag (from merge $sha)"
git tag --list --format='%(refname:short) %(objectname) %(taggerdate) %(describe)'

echo "push with git push $remote $tag"
