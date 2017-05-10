#!/usr/bin/env bash

if [ "$BUILDKITE_PULL_REQUEST" != "false" ]; then
    source ${BASH_SOURCE%/*}/buildkite_common.sh
    get_ancestor  # Writes $ANCESTOR_SHA variable.

    echo "--- Prep working directory"
    ./cleanfiles.sh

    PATH=$PATH:~/.local/bin  # fix for ubuntu paths

    echo "--- Running trapdoors tests"
    rm -rf ${QAWORKDIR}/*.pp

    TRAPDOORS="trapdoor_import.py
    trapdoor_pycodestyle.py
    trapdoor_pydocstyle.py"

    for i in ${TRAPDOORS}; do
        ${BASH_SOURCE%/*}/${i} feature
    done

    git checkout ${ANCESTOR_SHA}
    copy_qa_scripts

    for i in ${TRAPDOORS}; do
        ${QAWORKDIR}/${i} ancestor
    done

    for i in ${TRAPDOORS}; do
        ${QAWORKDIR}/${i} report
    done
fi
