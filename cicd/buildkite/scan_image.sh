#!/bin/bash

set -eu

buildkite-agent artifact download twistcli .
buildkite-agent artifact download token .

TOKEN=`cat token`

chmod u+x twistcli

JOB_NAME="JobName"
BUILD_ID="BuildName"
NODE_NAME="NodeName"
GIT_BRANCH="GITBranch"

./twistcli images scan --token $TOKEN --address $CONSOLE --details --output-file results.json --publish  --custom-labels  $APPNAME:$BUILDKITE_BUILD_NUMBER

buildkite-agent artifact upload results.json
