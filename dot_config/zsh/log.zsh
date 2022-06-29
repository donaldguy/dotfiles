# shellcheck shell=bash
# vim: ft=zsh

source ${ZDOTDIR}/utils.zsh

if [[ ! -v __dz__log_level ]] then
  declare -grAH __dz__log_levels=([debug]=0 [info]=1 [warn]=2 [error]=3)
  declare -grAH __dz__log_colors=([debug]="cyan:normal" [info]="cyan:bold" [warn]="yellow:bold" [error]="red:bold")
  declare -gH __dz__log_level="info"
fi

function __dz_valid_log_level() {
  case ${1:-} in
    debug|info|warn|error) return 0;;
    *) return 1
  esac
}

function ,log_level() {
  if [[ $# -eq 0 ]]; then
    echo $__dz__log_level; return 0;
  elif __dz_valid_log_level $1; then
    __dz__log_level=$1; return 0;
  fi
  if [[ $# -ne 0 ]] then ,log error "Given level \"$1\" is not a valid level."; fi
  ,log error  "Usage: ,log_level ${(k)__dz__log_levels// / | }"
  return 1
}

function ,log() {
  local level
  if   [[ $# -lt 1 ]]; then ,log error "Usage: ,log [level] <msg can contain spaces>";
  elif ! __dz_valid_log_level $1 ; then level=error;
  else level=$1; shift; fi
  local msg="$*"

  if [[ "${__dz__log_levels[$level]}" -ge "${__dz__log_levels[${__dz__log_level}]}" ]]; then
    local hue="${__dz__log_colors[$level]%:*}" base_weight="${__dz__log_colors[$level]#*:}"
    local base_color drop_color
    zstyle -s ":dz_color:fg:${base_weight}"      $hue  base_color
    zstyle -s ":dz_color:fg:${base_weight}:thin" $hue  drop_color

    printf "${base_color}[dz:%5s]${drop_color}%$(($(/usr/bin/tput cols || echo 80)-10))s\n${base_color}  %-78s${reset_color}\n" \
                          $level                      "(${funcfiletrace[1]})"                             "${msg}." >&2
  fi
}
