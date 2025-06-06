# interactive.bash - settings for any interactive session
# use these for things that you do at the prompt

set -o vi +o emacs

# https://bash-prompt-generator.org/
# basic prompt
#PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

GIT_PROMPT_FILE_NIXOS="/run/current-system/sw/share/bash-completion/completions/git-prompt.sh"
GIT_PROMPT_FILE_NIX="$HOME/.nix-profile/share/git/contrib/completion/git-prompt.sh"

if [[ -f "$GIT_PROMPT_FILE_NIXOS" ]]; then
  source "$GIT_PROMPT_FILE_NIXOS"
elif [[ -f "$GIT_PROMPT_FILE_NIX" ]]; then
  source "$GIT_PROMPT_FILE_NIX"
fi

update_prompt() {
  PS1='\[\e[92m\]\u\[\e[0m\]@\[\e[92m\]\H\[\e[0m\]:\[\e[38;5;37m\]\w\[\e[0m\]'

  if [[ $(command -v __git_ps1) ]]; then
    PS1_CMD1=$(__git_ps1 " (%s)")
    PS1+="\[\e[38;5;247m\]''${PS1_CMD1}\[\e[0m\]"

    if [ -n "$DIRENV_DIR" ]; then
      PS1+="% " # % for direnv directories
    else
      PS1+="\\$ " # $ for non-direnv directories
    fi
  fi
}

# manage history
merge_history() {
  history -n; history -w; history -c; history -r;
}
PROMPT_COMMAND='history -a;update_prompt'

# https://gist.github.com/daytonn/8677243
# Colors
end="\033[0m"
black="\033[0;30m"
blackb="\033[1;30m"
white="\033[0;37m"
whiteb="\033[1;37m"
red="\033[0;31m"
redb="\033[1;31m"
green="\033[0;32m"
greenb="\033[1;32m"
yellow="\033[0;33m"
yellowb="\033[1;33m"
blue="\033[0;34m"
blueb="\033[1;34m"
purple="\033[0;35m"
purpleb="\033[1;35m"
lightblue="\033[0;36m"
lightblueb="\033[1;36m"

black() {
  echo -e "''${black}''${1}''${end}"
}

blackb() {
  echo -e "''${blackb}''${1}''${end}"
}

white() {
  echo -e "''${white}''${1}''${end}"
}

whiteb() {
  echo -e "''${whiteb}''${1}''${end}"
}

red() {
  echo -e "''${red}''${1}''${end}"
}

redb() {
  echo -e "''${redb}''${1}''${end}"
}

green() {
  echo -e "''${green}''${1}''${end}"
}

greenb() {
  echo -e "''${greenb}''${1}''${end}"
}

yellow() {
  echo -e "''${yellow}''${1}''${end}"
}

yellowb() {
  echo -e "''${yellowb}''${1}''${end}"
}

blue() {
  echo -e "''${blue}''${1}''${end}"
}

blueb() {
  echo -e "''${blueb}''${1}''${end}"
}

purple() {
  echo -e "''${purple}''${1}''${end}"
}

purpleb() {
  echo -e "''${purpleb}''${1}''${end}"
}

lightblue() {
  echo -e "''${lightblue}''${1}''${end}"
}

lightblueb() {
  echo -e "''${lightblueb}''${1}''${end}"
}

colors() {
  black "black"
  blackb "blackb"
  white "white"
  whiteb "whiteb"
  red "red"
  redb "redb"
  green "green"
  greenb "greenb"
  yellow "yellow"
  yellowb "yellowb"
  blue "blue"
  blueb "blueb"
  purple "purple"
  purpleb "purpleb"
  lightblue "lightblue"
  lightblueb "lightblueb"
}

colortest() {
  # The test text
  if [[ ! -z "$1" ]]; then
    T="$1"
  else
    T='gYw'
  fi

  echo -e "\n                 40m     41m     42m     43m\
       44m     45m     46m     47m";

  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
             '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
             '  36m' '1;36m' '  37m' '1;37m';
    do FG=''${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
      do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
    done
    echo;
  done
  echo
}

# this makes all the color functions and variables available to scripts
# the functions are commented out because of a bug in devbox that clobbers the names and causes errors
# https://github.com/jetify-com/devbox/issues/995
#export -f colors
#export -f colortest
#export -f black
#export -f blackb
#export -f white
#export -f whiteb
#export -f red
#export -f redb
#export -f green
#export -f greenb
#export -f yellow
#export -f yellowb
#export -f blue
#export -f blueb
#export -f purple
#export -f purpleb
#export -f lightblue
#export -f lightblueb
export black
export blackb
export white
export whiteb
export red
export redb
export green
export greenb
export yellow
export yellowb
export blue
export blueb
export purple
export purpleb
export lightblue
export lightblueb
export end
