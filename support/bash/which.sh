#!/bin/bash

# BUG: MinGW on Windows doesn't find some executable (notably shell scripts in ~/bin)
#   via "which", but, oddly, running them works just fine. This seems to come from
#   missing executable flags on shell scripts, which cannot be set via chmod.

# TODO:
#   - Add suffixes, like .exe on windows

CHECK="test -x"
while [[ $# -gt 1 ]] ; do
    case $1 in
        -e)
            # Check only if it exists
            CHECK="test -e"
        ;;
        -f)
            # Check for any file
            CHECK="test -f"
        ;;
        -x)
            # Check for executable (default)
            CHECK="test -x"
        ;;
        -*)
            echo "Unknown option: $1"
            exit1
        ;;
        *)
            # Non option
            break;
    esac
    shift
done

NAME="$1"; shift

IFS=':' read -ra PATHELEMS <<< "$PATH"
for i in "${PATHELEMS[@]}"; do
    F="$i/$NAME"
    if $CHECK $F ; then
        echo $F
        break
    # else
    #     echo "Not $F"
    fi
done
