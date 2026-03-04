#!/bin/sh
# Claude Code status line - two-line informational display

input=$(cat)

# Parse JSON fields
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Convert duration to human-readable
duration_s=$((${duration_ms%.*} / 1000))
if [ "$duration_s" -ge 3600 ]; then
  hours=$((duration_s / 3600))
  mins=$(( (duration_s % 3600) / 60 ))
  duration="${hours}h${mins}m"
elif [ "$duration_s" -ge 60 ]; then
  mins=$((duration_s / 60))
  duration="${mins}m"
else
  duration="${duration_s}s"
fi

# Format context percentage
ctx_fmt=$(printf "%.1f%%" "$ctx_pct")

# Git branch
git_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "detached")

# ANSI colors
reset="\033[0m"
green="\033[0;32m"
yellow="\033[0;33m"
magenta="\033[0;35m"
cyan="\033[0;36m"

# Line 1: model, context, session
printf "${cyan}Model: %s${reset} | ${yellow}Ctx: %s${reset} | ${magenta}Session: %s${reset}\n" "$model" "$ctx_fmt" "$duration"

# Line 2: git icon, branch, stats
printf "${magenta}⌐ %s${reset} | ${green}(+%s,-%s)${reset}" "$git_branch" "$lines_added" "$lines_removed"
