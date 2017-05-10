#!/usr/bin/env bash

source ${BASH_SOURCE%/*}/common.sh
export NUM_FAILED=0

report_error() {
    echo -e "${RED}${1}${RESET}"
    ((NUM_FAILED++))
}

### Testing in the current branch

### a) Parts that are always done

# Check the author names
${BASH_SOURCE%/*}/check_names.py || report_error "Failed author/committer check (current branch)"
# Clean stuff
echo 'Cleaning source tree'
./cleanfiles.sh &> /dev/null
# In-place build of wfns
python setup.py build_ext -i || report_error "Failed to build wfns (current branch)"
# Run the slow tests
nosetests -v -a slow || report_error "Some slow tests failed (current branch)"
# Build the documentation
(cd doc; make html) || report_error "Failed to build documentation (current branch)"

### b) Parts that depend on the current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
ANCESTOR_COMMIT=$(git merge-base master ${CURRENT_BRANCH})
CURRENT_COMMIT=$(git rev-parse HEAD)
if [ "${CURRENT_BRANCH}" == 'master' ] || [ "${CURRENT_COMMIT}" == ${ANCESTOR_COMMIT} ]; then
    # Run the fast tests
    nosetests -v -a '!slow' || report_error "Some fast tests failed (master branch)"
else
    # Check for whitespace errors in every commit.
    ${BASH_SOURCE%/*}/check_whitespace.py || report_error "Whitespace errors in some commits"

    # Run the first part of the comparative tests.
    ${BASH_SOURCE%/*}/trapdoor_coverage.py feature || report_error "Trapdoor coverage failed (feature branch)"
    ${BASH_SOURCE%/*}/trapdoor_pylint.py feature || report_error "Trapdoor pylint failed (feature branch)"
    ${BASH_SOURCE%/*}/trapdoor_pycodestyle.py feature || report_error "Trapdoor pycodestyle failed (feature branch)"
    ${BASH_SOURCE%/*}/trapdoor_pydocstyle.py feature || report_error "Trapdoor pydocstyle failed (feature branch)"
    ${BASH_SOURCE%/*}/trapdoor_import.py feature || report_error "Trapdoor import failed (feature branch)"
    ${BASH_SOURCE%/*}/trapdoor_namespace.py feature || report_error "Trapdoor namespace failed (feature branch)"
fi

# Conclude
if [ "$NUM_FAILED" -gt 0 ]; then
    echo -e "${RED}SOME TESTS FAILED (current branch)${RESET}"
    exit 1
fi
echo -e "${GREEN}ALL TESTS PASSED (current branch)${RESET}"
exit 0
