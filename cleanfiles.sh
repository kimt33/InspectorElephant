#!/bin/bash

#
# This scripts removes files which pollute the working directory. These files are often generated
# while building the code and often must be cleared between rebuilds (if you have Cython/C++
# code) or if there are temporary files which are created by your project.
#
# You must reimplement the code below to match your project's requirements.
#

for i in $(find horton tools scripts | egrep "\.pyc$|\.py~$|\.pyc~$|\.bak$|\.so$") ; do rm -v ${i}; done
(cd doc; make clean)
rm -v MANIFEST
rm -vr dist
rm -vr build
rm -vr doctrees
rm -v .coverage
exit 0
