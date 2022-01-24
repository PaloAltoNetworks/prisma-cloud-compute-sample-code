#!/bin/bash

set -eu

docker build . -t $APPNAME:$BUILDKITE_BUILD_NUMBER

