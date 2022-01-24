#!/bin/bash

set -eu

curl -sk -H "Content-Type: application/json" -d "{\"username\":\"$USERNAME\", \"password\":\"$PASSWORD\"}" $CONSOLE/api/v1/authenticate | jq -r .token > token

buildkite-agent artifact upload token
