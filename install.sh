#!/usr/bin/env bash

cd ${BASH_SOURCE%/*}

cp -a pre-commit ../.git/hooks/
cp -a cleanfiles.sh ../
mkdir ../../qaworkdir
cp -a ./qa/trapdoor.cfg ../../qaworkdir
cp -a ./qa/pycodestyle.ini ../../qaworkdir
