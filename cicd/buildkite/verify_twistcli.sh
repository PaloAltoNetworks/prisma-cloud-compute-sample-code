#!/bin/bash

set -eu

buildkite-agent artifact download twistcli .

chmod u+x twistcli

./twistcli -v


