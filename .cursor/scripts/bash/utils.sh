#!/usr/bin/env bash

# Utils shell functions for spec-kit scripts.

write_log() {
    local message="$1"
    local color="${2:-}"
    local is_error="${3:-0}"

    [ "${SILENT:-0}" -eq 1 ] && return

    local color_code='\033[0m'
    case "${color}" in
        Red|red|"") color_code='\033[0;31m' ;;
        Green|green) color_code='\033[0;32m' ;;
        Yellow|yellow) color_code='\033[0;33m' ;;
        Blue|blue) color_code='\033[0;34m' ;;
        Magenta|magenta) color_code='\033[0;35m' ;;
        Cyan|cyan) color_code='\033[0;36m' ;;
    esac

    if [ "${is_error}" -eq 1 ]; then
        printf '%s%s%s\n' '\033[0;31m' "${message}" '\033[0m' >&2
        exit 1
    fi

    printf '%s%s%s\n' "${color_code}" "${message}" '\033[0m'
}
