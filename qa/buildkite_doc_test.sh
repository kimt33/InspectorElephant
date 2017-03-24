#!/usr/bin/env bash

#
# This script tests building the documentation of wfns.
#
# Reimplement as needed.
#

source ${BASH_SOURCE%/*}/buildkite_common.sh

echo "--- Prep working directory"
rm -rf *_pr.tar.gz *_ancestor.tar.gz
./cleanfiles.sh

export PYTHONPATH=$PWD

echo "--- Unpack PR build from previous step"
buildkite-agent artifact download wfns_pr.tar.gz .
tar xvf wfns_pr.tar.gz

echo "--- Building Docs"
make -C doc html
