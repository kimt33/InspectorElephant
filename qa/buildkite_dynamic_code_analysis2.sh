#!/usr/bin/env bash

#
# This script runs dynamic trapdoor tests on the code. It first cleans the working directory (you
# cannot assume it is already clean from previous builds) and then unpacks the compiled binaries
# from the previous buildkite step. Note that if you don't compile anything in a previous step,
# you should remove the download the artifacts portion of this script.
#
# There are two of these scripts in order to make use of parallelism in the buildkite agents. (They
# can run concurrently.)
#
# Use this as a template to implement any dynamic tests.
#

## Don't touch this code if you don't understand it ##
if [ "$BUILDKITE_PULL_REQUEST" != "false" ]; then
## END ##

    source ${BASH_SOURCE%/*}/buildkite_common.sh
    get_ancestor  # Writes $ANCESTOR_SHA variable.

    echo "--- Prep working directory"
    rm -rf *_pr.tar.gz *_ancestor.tar.gz
    ./cleanfiles.sh

    echo "--- Unpack PR build from previous step"
    buildkite-agent artifact download wfns_pr.tar.gz .
    tar xvf wfns_pr.tar.gz

    echo "--- Running trapdoors tests on PR branch"
    rm -rf ${QAWORKDIR}/*.pp
    ${BASH_SOURCE%/*}/trapdoor_pylint.py feature

    echo "--- Unpack ancestor build from previous step"
    git checkout ${ANCESTOR_SHA}
    buildkite-agent artifact download wfns_ancestor.tar.gz .
    ./cleanfiles.sh
    tar xvf wfns_ancestor.tar.gz

    echo "--- Running trapdoor tests on ancestor branch"
    copy_qa_scripts

    ${QAWORKDIR}/trapdoor_pylint.py ancestor
    ${QAWORKDIR}/trapdoor_pylint.py report

## Don't touch this code if you don't understand it ##
fi
## END ##
