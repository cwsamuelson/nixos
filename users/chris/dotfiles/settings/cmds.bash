# cmds.bash - general (not app-specific) aliases and functions.

# path pretty prints the path
alias path='echo "${PATH//:/$'\n'}"'

# psaux is ps aux if it searched for process names
psaux() {
  pgrep -f "$@" | xargs ps -fp 2>/dev/null
}

varfind() {
  find $${!1//:/ } -name $2 2>/dev/null
}

highlight() {
  egrep --color=always "''${1}|$" $2
}

tre() { command tre "$@" -e && source "/tmp/tre_aliases_$USER" 2>/dev/null; }

incognito() {
  if [[ -v oldhistfile ]] ; then
    yellowb "Exiting incognito"
    HISTFILE=$oldhistfile
    unset oldhistfile
  else
    yellowb "Entering incognito"
    oldhistfile=$HISTFILE
    HISTFILE=/dev/null
  fi
}

cheatsh() {
  curl -s cheat.sh/$1 | cat
}
