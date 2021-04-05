#!/bin/bash

#: installs hardlinks to the relevant files in this repo to home directory
#: creating directory structure if needed, backing up and replacing any found

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

QUIET=""
DRY_RUN=""

while [[ $# > 0 ]]; do
  case "$1" in
    -n)
      DRY_RUN="dryrun"
      ;;
    -q)
      QUIET="quiet"
      ;;
    *)
      exec >&2
      echo "Usage: $0 [-n] [-q]"
      echo "  -n    dry run; don't perform any actual modifications"
      echo "  -q    quiet-mode; don't include lines for files already correctly in place"
      exit 1
  esac
  shift
done

declare -r \
  GREEN_CHECKMARK="$(tput setaf 2)$(printf "\xE2\x9c\x94")$(tput sgr0)" \
  YELLOW_M="$(tput setaf 3)M$(tput sgr0)" \
  RED_C="$(tput setaf 1)C$(tput sgr0)" \
  HOSTNAME="$(hostname)" \
  BACKUP_SUFFIX="$(date +"%Y-%m-%d.%H-%M").bak"

declare -a relevant_files_in_git replaced
declare -i in_place=0 created=0

print_summary() {
  printf "\n\n"
  if [[ -n "$DRY_RUN" ]]; then echo "If this were not a dry run, the results would be: "; fi
  printf "%d Created, %d Replaced, %d Already in-place\n" $created "${#replaced[@]}" $in_place

  if [[ "${#replaced[@]}" > 0 ]]; then
    echo
    if [[ -n "$DRY_RUN" ]]; then echo "If this were not a dry run, you'd want to"; fi
    echo "Consider checking the following diffs:"
    for backedup in "${replaced[@]}"; do
      echo "  diff '$backedup.$BACKUP_SUFFIX' '$backedup'"
    done
  fi
}

trap print_summary EXIT

relevant_files_in_git=(
  $(git ls-files -- all/ )
  $(git ls-files -- "$HOSTNAME/")
)

for gitfile in "${relevant_files_in_git[@]}"; do
  host_dir="${gitfile%%/*}"
  dotfile="${gitfile#*/}"

  src_location="$gitfile"
  dst_location="$HOME/$dotfile"

  if [[ -f "$dst_location" && "$dst_location" -ef "$src_location" ]]; then
    if [[ -z "$QUIET" ]]; then
      printf "%s [%${#HOSTNAME}s] %s\n" $GREEN_CHECKMARK $host_dir $dotfile
    fi

    in_place+=1
  elif [[ -f "$dst_location" ]]; then

    if [[ -z "$DRY_RUN" ]]; then
      mv "$dst_location" "$dst_location.$BACKUP_SUFFIX"
      ln "$src_location" "$dst_location"
    fi
    replaced+=("$dst_location")

    printf "%s [%${#HOSTNAME}s] %s\n" $YELLOW_M "$host_dir" "$dotfile"
  else
    if [[ -z "$DRY_RUN" ]]; then
      mkdir -p "$(dirname $dst_location)"
      ln "$src_location" "$dst_location"
    fi

    printf "%s [%${#HOSTNAME}s] %s\n" $RED_C $host_dir $dotfile
    created+=1
  fi
done
