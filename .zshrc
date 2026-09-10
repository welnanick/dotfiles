# Load Dir Colors first, so LS_COLORS is set before anything else happens
if [[ -f /home/nick/.dir_colors ]]; then
    eval `dircolors /home/nick/.dir_colors`
fi

export EDITOR=vim
export VISUAL=vim

source '/usr/share/zsh-antidote/antidote.zsh'
antidote load

# Dynamic ZSH completions
source <(COMPLETE=zsh jj)

zstyle ':zephyr:plugin:autosuggest' 'highlight' 'fg=10'
zstyle ':zephyr:plugin:history-search' 'highlight' ''
zstyle ':zephyr:plugin:prompt' 'theme' 'starship'

ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main brackets cursor)

# Add a newline between commands, but not before first prompt when first opening the terminal or after clearing the
# terminal.
# https://github.com/starship/starship/issues/560
precmd() { 
    precmd() {
        echo "" 
    } 
}
alias clear="precmd() { precmd() { echo } } && clear"

# Function for setting window title, based on the one used in Oh My Zsh, but only the parts relevant to my setup.
function title {
  setopt localoptions nopromptsubst

  # Don't set the title if inside emacs, unless using vterm
  [[ -n "${INSIDE_EMACS:-}" && "$INSIDE_EMACS" != vterm ]] && return

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  print -Pn "\e]2;${2:q}\a" # set window name
}

ZSH_THEME_TERM_TITLE_IDLE="%n@%m:%~"

# precmd to set window title, based on the one used in Oh My Zsh.
function termsupport_precmd {
    title "$ZSH_THEME_TERM_TITLE_IDLE"
}

# preexec to set window title, based on the one used in Oh My Zsh.
function termsupport_preexec {

  emulate -L zsh
  setopt extended_glob

  # split command into array of arguments
  local -a cmdargs
  cmdargs=("${(z)2}")
  # if running fg, extract the command from the job description
  if [[ "${cmdargs[1]}" = fg ]]; then
    # get the job id from the first argument passed to the fg command
    local job_id jobspec="${cmdargs[2]#%}"
    # logic based on jobs arguments:
    # http://zsh.sourceforge.net/Doc/Release/Jobs-_0026-Signals.html#Jobs
    # https://www.zsh.org/mla/users/2007/msg00704.html
    case "$jobspec" in
      <->) # %number argument:
        # use the same <number> passed as an argument
        job_id=${jobspec} ;;
      ""|%|+) # empty, %% or %+ argument:
        # use the current job, which appears with a + in $jobstates:
        # suspended:+:5071=suspended (tty output)
        job_id=${(k)jobstates[(r)*:+:*]} ;;
      -) # %- argument:
        # use the previous job, which appears with a - in $jobstates:
        # suspended:-:6493=suspended (signal)
        job_id=${(k)jobstates[(r)*:-:*]} ;;
      [?]*) # %?string argument:
        # use $jobtexts to match for a job whose command *contains* <string>
        job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]} ;;
      *) # %string argument:
        # use $jobtexts to match for a job whose command *starts with* <string>
        job_id=${(k)jobtexts[(r)${(Q)jobspec}*]} ;;
    esac

    # override preexec function arguments with job command
    if [[ -n "${jobtexts[$job_id]}" ]]; then
      1="${jobtexts[$job_id]}"
      2="${jobtexts[$job_id]}"
    fi
  fi

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
  local LINE="${2:gs/%/%%}"

  title "$CMD" "%100>...>${LINE}%<<"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd termsupport_precmd
add-zsh-hook preexec termsupport_preexec

ZLE_RPROMPT_INDENT=0
