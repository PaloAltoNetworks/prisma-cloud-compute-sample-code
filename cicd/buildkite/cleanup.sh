#!/bin/bash

set -eu


docker rmi $APPNAME:$BUILDKITE_BUILD_NUMBER
