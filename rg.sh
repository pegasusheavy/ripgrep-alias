#!/bin/sh
# Source this file in your shell profile to wrap ripgrep with GNU grep
# -E (--extended-regexp) compatibility:
#
#   . /path/to/rg.sh
#
# GNU grep -E enables extended regular expressions. ripgrep uses an
# equivalent regex syntax by default, so this wrapper strips -E and
# --extended-regexp from the argument list before forwarding to rg.
#
# If you need ripgrep's native -E (--encoding) flag, use --encoding.

rg() {
    local n=$# i=0 arg
    while [ "$i" -lt "$n" ]; do
        i=$((i + 1))
        arg="$1"
        shift
        case "$arg" in
            -E|--extended-regexp) ;;
            *) set -- "$@" "$arg" ;;
        esac
    done
    command rg "$@"
}
