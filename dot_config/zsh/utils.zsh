if [[ ! -v dawn_zsh_do_func_once_already_ran || -v no_really_reload_utils ]]; then

  declare -AHg dawn_zsh_do_func_once_already_ran

  function __do_func_once() {
    if [[ ! -v dawn_zsh_do_func_once_already_ran[$1] ]]; then
      eval "$@"
    fi
  }

  function __source_if_exists() {
    if [[ -f "$1" ]]; then source $1; else ,log warn "$1 was not found, so not sourced"; fi
  }

  function __eval_output_if_exists() {
    if [[ -x "$1" ]]; then
      local output="$("$@")"
      if [[ -n output ]]; then
        ,log debug "About to eval \"\"\""$'\n'"$output"$'\n'"\"\"\" from running \`$*\`"
        eval "$output"
      fi
    elif [[ -f "$1" ]]; then
        ,log warn "$1 exists but is not executable, so did not do \`eval \"\$($*)\"\`"
    else
        ,log warn "$1 for\n  eval \"\$($*)\"\n was not found"
    fi
  }

  function __init__dz_colors() {
    autoload colors; colors
    zmodload zsh/zutil

    for hue in ${(k)fg_bold}; do
      local bold="${fg_bold[$hue]}" normal="${fg_no_bold[$hue]}"
      local faint="${fg_bold[$hue]//$color[bold]/$color[faint]}"

      zstyle ":dz_color:fg"                  "${hue}" "$normal"
      zstyle ":dz_color:fg:bold"             "${hue}" "$bold"
      zstyle ":dz_color:fg:normal"           "${hue}" "$normal"
      zstyle ":dz_color:fg:faint"            "${hue}" "$faint"

      zstyle ":dz_color:fg:*:thin:thin"      "${hue}" "$faint"
      zstyle ":dz_color:fg:normal:thin"      "${hue}" "$faint"
      zstyle ":dz_color:fg:bold:thin"        "${hue}" "$normal"
      zstyle ":dz_color:fg:faint:thic"       "${hue}" "$normal"
      zstyle ":dz_color:fg:normal:thic"      "${hue}" "$bold"
      zstyle ":dz_color:fg:*:thic:thic"      "${hue}" "$bold"
    done
  }

  __do_func_once __init__dz_colors
fi
