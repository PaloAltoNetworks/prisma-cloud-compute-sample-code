#!/bin/bash

set -eu

buildkite-agent artifact download token .

TOKEN=`cat token`

curl -vk -H "Authorization: Bearer $TOKEN" "$CONSOLE/api/v1/util/twistcli" > twistcli

buildkite-agent artifact upload twistcli
