#!/usr/bin/env bash
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# title      Solarized Osaka                                          +
# version    1.0.0                                                    +
# repository https://github.com/MiohitoKiri5474/solarized-osaka-tmux  +
# author     MiohitoKiri5474                                          +
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_PATH="$CURRENT_DIR/src"

source $SCRIPTS_PATH/themes.sh

tmux set -g status-left-length 80
tmux set -g status-right-length 150

RESET="#[fg=${THEME[foreground]},bg=${THEME[black]},nobold,noitalics,nounderscore,nodim]"
# Highlight colors
tmux set -g mode-style "fg=${THEME[bgreen]},bg=${THEME[bblack]}"

tmux set -g message-style "bg=${THEME[foreground]},fg=${THEME[black]}"
tmux set -g message-command-style "fg=${THEME[white]},bg=${THEME[black]}"

tmux set -g pane-border-style "fg=${THEME[bblack]}"
tmux set -g pane-active-border-style "fg=${THEME[bblack]}"
tmux set -g pane-border-status off

tmux set -g status-style bg="${THEME[black]}"

TMUX_VARS="$(tmux show -g)"

default_window_id_style="digital"
default_pane_id_style="hsquare"
default_zoom_id_style="dsquare"

window_id_style="$(echo "$TMUX_VARS" | grep '@solarized-osaka-tmux_window_id_style' | cut -d" " -f2)"
pane_id_style="$(echo "$TMUX_VARS" | grep '@solarized-osaka-tmux_pane_id_style' | cut -d" " -f2)"
zoom_id_style="$(echo "$TMUX_VARS" | grep '@solarized-osaka-tmux_zoom_id_style' | cut -d" " -f2)"
window_id_style="${window_id_style:-$default_window_id_style}"
pane_id_style="${pane_id_style:-$default_pane_id_style}"
zoom_id_style="${zoom_id_style:-$default_zoom_id_style}"

netspeed="#($SCRIPTS_PATH/netspeed.sh)"
cmus_status="#($SCRIPTS_PATH/music-tmux-statusbar.sh)"
git_status="#($SCRIPTS_PATH/git-status.sh #{pane_current_path})"
wb_git_status="#($SCRIPTS_PATH/wb-git-status.sh #{pane_current_path} &)"
window_number="#($SCRIPTS_PATH/custom-number.sh #I $window_id_style)"
custom_pane="#($SCRIPTS_PATH/custom-number.sh #P $pane_id_style)"
zoom_number="#($SCRIPTS_PATH/custom-number.sh #P $zoom_id_style)"
date_and_time="$($SCRIPTS_PATH/datetime-widget.sh)"
current_path="#($SCRIPTS_PATH/path-widget.sh #{pane_current_path})"
battery_status="#($SCRIPTS_PATH/battery-widget.sh)"

#+--- Bars LEFT ---+
# Session name
tmux set -g status-left "#[fg=${THEME[bblack]},bg=${THEME[bmagenta]},bold] #{?client_prefix,󰠠 ,#[dim]󰤂 }${RESET}#[fg=${THEME[bblack]},bg=${THEME[bmagenta]}]#(whoami) "

#+--- Windows ---+
# Focus
tmux set -g window-status-current-format "${RESET}#[bg=${THEME[white]}] #[fg=${THEME[magenta]},bold,nodim]$window_number #W#[nobold]#{?window_zoomed_flag, $zoom_number, $custom_pane}"
# Unfocused
tmux set -g window-status-format "${RESET}#{?window_last_flag, #[fg=${THEME[yellow]}], }$window_number #W#[nobold,dim]#{?window_zoomed_flag, $zoom_number, $custom_pane}"

#+--- Bars RIGHT ---+
tmux set -g status-right "$battery_status$current_path$cmus_status$netspeed$git_status$date_and_time #[fg=${THEME[black]},bg=${THEME[magenta]}] #H"
tmux set -g window-status-separator ""
