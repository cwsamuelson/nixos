#!/usr/bin/env bash

if [[ -n ${NO_COLOR:-} ]]; then
  end=""
  black=""
  blackb=""
  white=""
  whiteb=""
  red=""
  redb=""
  green=""
  greenb=""
  yellow=""
  yellowb=""
  blue=""
  blueb=""
  purple=""
  purpleb=""
  lightblue=""
  lightblueb=""
else
  # https://gist.github.com/daytonn/8677243
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
fi

black() {
  echo -e "$black$@$end"
}

blackb() {
  echo -e "$blackb$@$end"
}

white() {
  echo -e "$white$@$end"
}

whiteb() {
  echo -e "$whiteb$@$end"
}

red() {
  echo -e "$red$@$end"
}

redb() {
  echo -e "$redb$@$end"
}

green() {
  echo -e "$green$@$end"
}

greenb() {
  echo -e "$greenb$@$end"
}

yellow() {
  echo -e "$yellow$@$end"
}

yellowb() {
  echo -e "$yellowb$@$end"
}

blue() {
  echo -e "$blue$@$end"
}

blueb() {
  echo -e "$blueb$@$end"
}

purple() {
  echo -e "$purple$@$end"
}

purpleb() {
  echo -e "$purpleb$@$end"
}

lightblue() {
  echo -e "$lightblue$@$end"
}

lightblueb() {
  echo -e "$lightblueb$@$end"
}

# this makes all the color functions and variables available to scripts
export -f black
export -f blackb
export -f white
export -f whiteb
export -f red
export -f redb
export -f green
export -f greenb
export -f yellow
export -f yellowb
export -f blue
export -f blueb
export -f purple
export -f purpleb
export -f lightblue
export -f lightblueb
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
