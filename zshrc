#!/bin/zsh
export PS1="$(print '%{\e[1;36m%}%m%{\e[0m%}'): "
#setopt prompt_subst
#autoload -Uz vcs_info
#zstyle ':vcs_info:*' actionformats \
#    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
#zstyle ':vcs_info:*' formats       \
#    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
#zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
#
#zstyle ':vcs_info:*' enable git cvs svn
#
# or use pre_cmd, see man zshcontrib
#vcs_info_wrapper() {
#  vcs_info
#  if [ -n "$vcs_info_msg_0_" ]; then
#    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
#  fi
#}
#RPROMPT=$'$(vcs_info_wrapper)'

#PROMPT='%B%m%~%b$(git_super_status) %# '

#export PATH=/home/george/downloads/gnat-2011-i686-gnu-linux-libc2.3-bin/bin:${PATH}
#export PATH=/opt/rtems-4.11/bin:${PATH}
#export RTEMS_MAKEFILE_PATH=/opt/rtems-4.11/sparc-rtems4.11/sis
export PATH=/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH
NNTPSERVER='news.eternal-september.org:119'
export NNTPSERVER
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
export EDITOR="vim"
bindkey -e
autoload -U promptinit
promptinit
autoload -U compinit
compinit
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
#http_proxy=http://127.0.0.1:8118/
#HTTP_PROXY=$http_proxy
#export http_proxy HTTP_PROXY
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
eval $( dircolors -b /home/george/.LS_COLORS )
alias share="sh /home/george/script/share.sh"
alias grep="grep --color"
alias ssh="TERM=linux ssh"
alias telnet="TERM=linux telnet"
alias a="alsamixer"
alias ec="emacsclient -c -nw"
alias ecg="emacsclient -c"
#alias bat="awk '/remaining capacity/ { print $3 }' /proc/acpi/battery/BAT0/state"
alias bat="cat /sys/class/power_supply/BAT0/charge_now|head -c -4"
alias ls="ls -p -X --color=auto --group-directories-first"
#alias ls="/home/george/build/ls--/ls++"
alias quote="ruby /home/george/coding/ruby/testing/quote.rb"
alias rss="snownews"
alias irc="sh /home/george/script/irc.sh"
alias wpa="sh /home/george/script/wpa.sh"
alias wep="sh /home/george/script/wep.sh"
alias pacs="pacsearch"
pacsearch () {
       echo -e "$(pacman -Ss $@ | sed \
       -e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
       -e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
       -e 's#community/.*#\\033[1;35m&\\033[0;37m#g' \
       -e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g' )"
}


typeset -gA ZSH_HIGHLIGHT_STYLES

# An `object' implemented by below 3 arrays' elements could be called a
# `highlighter', registered by `_zsh_highlight_add-highlighter`. In
# other words, these arrays are indexed and tied by their own
# functionality. If they have been arranged inconsistently, things goes
# wrong. Please see `_zsh_highlight-zle-buffer` and `_zsh_highlight_add-
# highlighter`.


# Actual recolorize functions to be called.
typeset -a zsh_highlight_functions; zsh_highlight_functions=()

# Predicate functions whether its recolorize function should be called or not.
typeset -a zsh_highlight_predicates; zsh_highlight_predicates=()

# Highlight storages for each recolorize functions.
typeset -a zsh_highlight_caches; zsh_highlight_caches=()

_zsh_highlight-zle-buffer() {
  if (( PENDING )); then
    return
  fi

  local ret=$?
  {
    local -a funinds
    local -i rh_size=$#region_highlight
    for i in {1..${#zsh_highlight_functions}}; do
      local pred=${zsh_highlight_predicates[i]}
      local cache_place=${zsh_highlight_caches[i]}
      if _zsh_highlight-zle-buffer-p "$rh_size" "$pred"; then
        if ((${#${(P)cache_place}} > 0)); then
          region_highlight=(${region_highlight:#(${(P~j.|.)cache_place})})
          local -a empty; empty=(); : ${(PA)cache_place::=$empty}
        fi
        funinds+=$i
      fi
    done
    for i in $funinds; do
      local func=${zsh_highlight_functions[i]}
      local cache_place=${zsh_highlight_caches[i]}
      local -a rh; rh=($region_highlight)
      {
        "$func"
      } always  {
        : ${(PA)cache_place::=${region_highlight:#(${(~j.|.)rh})}}
      }
    done
  } always {
    ZSH_PRIOR_CURSOR=$CURSOR
    ZSH_PRIOR_HIGHLIGHTED_BUFFER=$BUFFER
    return $ret
  }
}

# Whether supplied highlight_predicate satisfies or not.
_zsh_highlight-zle-buffer-p() {
  local region_highlight_size="$1" highlight_predicate="$2"
  # If any highlightings are not taken into account, asume it is needed.
  # This holds for some up/down-history commands, for example.
  ((region_highlight_size == 0)) || "$highlight_predicate"
}

# Whether the command line buffer is modified or not.
_zsh_highlight_buffer-modified-p() {
  [[ ${ZSH_PRIOR_HIGHLIGHTED_BUFFER:-} != $BUFFER ]]
}

# Whether the cursor is moved or not.
_zsh_highlight_cursor-moved-p() {
  ((ZSH_PRIOR_CURSOR != $CURSOR))
}

# Register an highlighter.
_zsh_highlight_add-highlighter() {
  zsh_highlight_functions+="$1"
  zsh_highlight_predicates+="${2-${1}-p}"
  zsh_highlight_caches+="${3-${1//-/_}}"
}


# Main highlighter

ZSH_HIGHLIGHT_STYLES+=(
  default                       'fg=248'
  unknown-token                 'fg=196,bold,bg=234'
  reserved-word                 'fg=197,bold'
  alias                         'fg=197,bold'
  builtin                       'fg=107,bold'
  function                      'fg=85,bold'
  command                       'fg=166,bold'
  hashed-command                'fg=70'
  path                          'fg=30'
  globbing                      'fg=170,bold'
  history-expansion             'fg=blue'
  single-hyphen-option          'fg=244'
  double-hyphen-option          'fg=244'
  back-quoted-argument          'fg=220,bold'
  single-quoted-argument        'fg=137'
  double-quoted-argument        'fg=137'
  dollar-double-quoted-argument 'fg=148'
  back-double-quoted-argument   'fg=172,bold'
  assign                        'fg=240,bold'
)

mkstyle () {
  local lastlast
  local last

  while [ "$#" -gt 0 ]; do
    cur=$1
    shift

    if [ "$last" = 5 ]; then
      if [ "$lastlast" = 38 ]; then
        style+=( "fg=$cur" )
        lastlast=
        last=
        continue
      elif [ "$lastlast" = 48 ]; then
        style+=( "bg=$cur" )
        lastlast=
        last=
        continue
      fi
    fi

    lastlast=$last
    last=$cur
  done

  case "$last" in
    00|0) style+=( "none" )       ;;
    01|1) style+=( "bold" )       ;;
    04|4) style+=( "underscore" ) ;;
    05|5) style+=( "blink" )      ;;
    07|7) style+=( "reverse" )    ;;
    08|8) style+=( "concealed" )  ;;
  esac
}

function {
  local coloring ext rawstyle
  local -a style

  for coloring in ${(s.:.)LS_COLORS}; do
    ext=${coloring%%\=*}
    rawstyle=${coloring##*\=}
    style=()

    mkstyle ${(s.;.)rawstyle}
    style=${(j.,.)style}

    ZSH_HIGHLIGHT_STYLES+=(
      "$ext" "$style"
    )
  done
}

# Tokens that are always immediately followed by a command.
ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS=(
  '|' '||' ';' '&' '&&' 'noglob' 'nocorrect' 'builtin'
)

# Check if the argument is variable assignment
_zsh_highlight_check-assign() {
    setopt localoptions extended_glob
    [[ ${(Q)arg} == [[:alpha:]_]([[:alnum:]_])#=* ]]
}

# Check if the argument is a path.
_zsh_highlight_check-path() {
  [[ -z ${(Q)arg} ]] && return 1
  [[ -e ${(Q)arg} ]] && return 0
  [[ ! -e ${(Q)arg:h} ]] && return 1
  [[ ${#BUFFER} == $end_pos && -n $(print ${(Q)arg}*(N)) ]] && return 0
  return 1
}

# Highlight special chars inside double-quoted strings
_zsh_highlight_highlight_string() {
  setopt localoptions noksharrays
  local i j k style
  # Starting quote is at 1, so start parsing at offset 2 in the string.
  for (( i = 2 ; i < end_pos - start_pos ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      '$')  style=$ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument];;
      '%')  style=$ZSH_HIGHLIGHT_STYLES[globbing];;
      '^')  style=$ZSH_HIGHLIGHT_STYLES[globbing];;
      "\\") style=$ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]
            (( k += 1 )) # Color following char too.
            (( i += 1 )) # Skip parsing the escaped char.
            ;;
      *)    continue;;
    esac
    region_highlight+=("$j $k $style")
  done
}

# Core syntax highlighting.
_zsh_main-highlight() {
  setopt localoptions extendedglob bareglobqual
  local start_pos=0 end_pos highlight_glob=true new_expression=true arg style
  region_highlight=()

  for arg in ${(z)BUFFER}; do
    local substr_color=0

    style=

    [[ $start_pos -eq 0 && $arg = 'noglob' ]] && highlight_glob=false

    ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]##[[:space:]]#}}))
    ((end_pos=$start_pos+${#arg}))

    if $new_expression; then
      new_expression=false

      res=$(LC_ALL=C builtin type -w $arg 2>/dev/null)
      case $res in
        *': reserved')  style=$ZSH_HIGHLIGHT_STYLES[reserved-word];;
        *': alias')     style=$ZSH_HIGHLIGHT_STYLES[alias]
                        local aliased_command="${"$(alias $arg)"#*=}"
                        [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$aliased_command"} && -z ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$arg"} ]] && ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS+=($arg)
                        ;;
        *': builtin')   style=$ZSH_HIGHLIGHT_STYLES[builtin];;
        *': function')  style=$ZSH_HIGHLIGHT_STYLES[function];;
        *': command')   style=$ZSH_HIGHLIGHT_STYLES[command];;
        *': hashed')    style=$ZSH_HIGHLIGHT_STYLES[hashed-command];;
        *)              if _zsh_highlight_check-assign; then
                          style=$ZSH_HIGHLIGHT_STYLES[assign]
                          new_expression=true
                        elif _zsh_highlight_check-path; then
                          style=$ZSH_HIGHLIGHT_STYLES[path]
                        elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                          style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                        else
                          style=$ZSH_HIGHLIGHT_STYLES[unknown-token]
                        fi
                        ;;
      esac
    else
      for key in ${(k)ZSH_HIGHLIGHT_STYLES}; do
        case $key in
          "*."*) ;;
          *) continue ;;
        esac
        case $arg in
          $key) style=$ZSH_HIGHLIGHT_STYLES[$key] ;;
        esac
        [ -n "$style" ] && break
      done
      if [ -z "$style" ]; then
        case $arg in
          '--'*)   style=$ZSH_HIGHLIGHT_STYLES[double-hyphen-option];;
          '-'*)    style=$ZSH_HIGHLIGHT_STYLES[single-hyphen-option];;
          "'"*"'") style=$ZSH_HIGHLIGHT_STYLES[single-quoted-argument];;
          '"'*'"') style=$ZSH_HIGHLIGHT_STYLES[double-quoted-argument]
                   region_highlight+=("$start_pos $end_pos $style")
                   _zsh_highlight_highlight_string
                   substr_color=1
                   ;;
          '`'*'`') style=$ZSH_HIGHLIGHT_STYLES[back-quoted-argument];;
          *"*"*)   $highlight_glob && style=$ZSH_HIGHLIGHT_STYLES[globbing] ||
                     style=$ZSH_HIGHLIGHT_STYLES[default];;
          *)       if _zsh_highlight_check-path; then
                     style=$ZSH_HIGHLIGHT_STYLES[path]
                   elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                     style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                   else
                     style=$ZSH_HIGHLIGHT_STYLES[default]
                   fi
                   ;;
        esac
      fi
    fi
    [[ $substr_color = 0 ]] &&
      region_highlight+=("$start_pos $end_pos $style")
    [[ -n ${(M)ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS:#"$arg"} ]] && new_expression=true
    start_pos=$end_pos
  done
}


# Setup functions

# Intercept specified ZLE events to have highlighting triggered.
_zsh_highlight_bind-events() {

  # Resolve event names what have to be bound to.
  zmodload zsh/zleparameter 2>/dev/null || {
    echo 'zsh-syntax-highlighting:zmodload error. exiting.' >&2
    return -1
  }
  local -a events; : ${(A)events::=${@:#(_*|orig-*|.run-help|.which-command)}}

  # Bind the events to _zsh_highlight-zle-buffer.
  local clean_event
  for event in $events; do
    if [[ "$widgets[$event]" == completion:* ]]; then
      eval "zle -C orig-$event ${${${widgets[$event]}#*:}/:/ } ; $event() { builtin zle orig-$event && _zsh_highlight-zle-buffer } ; zle -N $event"
    else
      case $event in
        accept-and-menu-complete)
          eval "$event() { builtin zle .$event && _zsh_highlight-zle-buffer } ; zle -N $event"
          ;;
        .*)
          # Remove the leading dot in the event name
          clean_event=$event[2,${#event}]
          case ${widgets[$clean_event]-} in
            (completion|user):*)
              ;;
            *)
              eval "$clean_event() { builtin zle $event && _zsh_highlight-zle-buffer } ; zle -N $clean_event"
              ;;
          esac
          ;;
        *)
          ;;
      esac
    fi
  done
}

# Load highlighters from specified directory if it exists.
_zsh_highlight_load-highlighters() {
  [[ -d $1 ]] && for highlighter_def ($1/*.zsh) . $highlighter_def
}


# Setup

# Bind highlighting to all known events.
_zsh_highlight_bind-events "${(@f)"$(zle -la)"}"

# Register the main highlighter.
_zsh_highlight_add-highlighter _zsh_main-highlight _zsh_highlight_buffer-modified-p

# Load additional highlighters if available.
_zsh_highlight_load-highlighters "${${(%):-%N}:h}/highlighters"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
