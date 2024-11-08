#!/usr/bin/env bash

# base on solarized-osaka with solarized

declare -A THEME=(
  ["background"]="#0d2a34"
  ["foreground"]="#869395"
  ["black"]="#163540"
  ["blue"]="#4689cc"
  ["cyan"]="#519e97"
  ["green"]="#88982d"
  ["magenta"]="#c24380"
  ["red"]="#ca4238"
  ["white"]="#ece8d6"
  ["yellow"]="#ae8a2c"

  ["bblack"]="#0d2a34"
  ["bblue"]="#869395"
  ["bcyan"]="#95a0a0"
  ["bgreen"]="#5c6d74"
  ["bmagenta"]="#6c70be"
  ["bred"]="#bc5329"
  ["bwhite"]="#fbf6e4"
  ["byellow"]="#697a81"
)

THEME['ghgreen']="#3fb950"
THEME['ghmagenta']="#A371F7"
THEME['ghred']="#d73a4a"
THEME['ghyellow']="#d29922"

RESET="#[fg=${THEME[foreground]},bg=${THEME[background]},nobold,noitalics,nounderscore,nodim]"
