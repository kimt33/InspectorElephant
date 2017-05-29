#!/usr/bin/env bash

#
# This script tests building the documentation of packagename.
#
# Reimplement as needed.
#

source ${BASH_SOURCE%/*}/buildkite_common.sh

echo "--- Prep working directory"
rm -rf *_pr.tar.gz *_ancestor.tar.gz
./cleanfiles.sh

export PYTHONPATH=$PWD

echo "--- Unpack PR build from previous step"
buildkite-agent artifact download packagename_pr.tar.gz .
tar xvf packagename_pr.tar.gz

echo "--- Building Docs"
make -C doc html
