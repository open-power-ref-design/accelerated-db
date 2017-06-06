#!/bin/bash

#
# Prepare and apply all patches for:
#
# 1) general fixes (e.g. backports) that aren't present in the release
#    we're building
#
# 2) updates specific to _building_ on POWER (but not fixes specific
#    to packaging; those belong in the packaging steps
#
# Exit 0 on success; 1 on failure
#

if [ -z "$1" -o ! -z "$2" ]
then
    echo "Usage: $(basename $0) <source-tree-base>"
    exit 1
fi

SOURCE="$1"
OPWD=$(pwd)

if [ ! -d "$1" ]
then
    echo "ERROR: $SOURCE is not a directory"
    exit 1
fi

if [ -x "./prepare_patches.sh" ]
then
    echo "Preparing patches"
    if ! ./prepare_patches.sh
    then
        echo "ERROR: Failed to prepare patches"
        exit 1
    fi
fi

cd "${SOURCE}"
ls -1 ../patches/*patch 2>/dev/null | sort | while read pfile
do
    echo "Applying patch: ${pfile}"
    if ! patch -p1 < "${pfile}"
    then
        echo "ERROR: Patch application failed ${pfile}"
        cd "$OPWD"
        exit 1
    fi
done
cd "$OPWD"

exit 0

