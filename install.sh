#!/usr/bin/env bash

cd ${BASH_SOURCE%/*}

cat .gitignore >> ../../.gitignore
cp -a pre-commit ../../.git/hooks/
cp -a cleanfiles.sh ../../
