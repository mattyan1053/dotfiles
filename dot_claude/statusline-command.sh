#!/usr/bin/env bash
# Claude Code statusLine command
# Mirrors the bash PS1 from ~/.bash_prompt:
#   [time] [user@host] [cwd] [git branch] [usage 5h/7d]

input=$(cat)

# Parse everything we need from the JSON payload in a single jq pass
# (tab-separated). rate_limits.* is present only on subscription plans and
# recent CLI versions; it falls back to "" and the usage segment is hidden.
cwd=""
five_pct=""
seven_pct=""
if command -v jq >/dev/null 2>&1; then
  IFS=$'\t' read -r cwd five_pct seven_pct < <(
    printf '%s' "$input" | jq -r '
      [ (.cwd // .workspace.current_dir // "")
      , (.rate_limits.five_hour.used_percentage // "")
      , (.rate_limits.seven_day.used_percentage // "")
      ] | @tsv'
  )
fi
[ -z "$cwd" ] && cwd="$(pwd)"

user="$(whoami)"
host="$(hostname -s)"
time_str="$(date +%H:%M:%S)"

# Git branch (skip optional lock to avoid interference)
git_branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree --no-optional-locks 2>/dev/null | grep -q true; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" describe --tags --exact-match 2>/dev/null \
    || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Color segments (matching the original PS1 style).
# Use an actual ESC byte via ANSI-C quoting so the segments can be printed
# with a constant "%s" format. cwd and branch names are untrusted and may
# contain printf metacharacters (e.g. a path ending in "100%done"), so they
# must never be part of the format string.
esc=$'\e'
# Segment: time (black on white)
seg_time="${esc}[30;47m  ${time_str} ${esc}[0m"
# Segment: user@host (white on blue)
seg_user="${esc}[37;44m ${user}@${host} ${esc}[0m"
# Segment: cwd (white on red)
seg_cwd="${esc}[00;41m  ${cwd} ${esc}[0m"

# Segment: git branch (black on yellow)
seg_git=""
[ -n "$git_branch" ] && seg_git="${esc}[30;43m  ${git_branch} ${esc}[0m"

# Segment: Claude usage (5h / 7d rate-limit percentages).
# Colored by the higher of the two: <50 magenta, 50-79 yellow, >=80 red.
seg_usage=""
if [ -n "$five_pct" ] || [ -n "$seven_pct" ]; then
  five_int="${five_pct%%.*}"
  seven_int="${seven_pct%%.*}"
  usage_text=""
  [ -n "$five_pct" ] && usage_text="5h ${five_int:-0}%"
  [ -n "$seven_pct" ] && usage_text="${usage_text:+$usage_text · }7d ${seven_int:-0}%"

  max_pct=0
  [ -n "$five_int" ] && [ "$five_int" -gt "$max_pct" ] 2>/dev/null && max_pct="$five_int"
  [ -n "$seven_int" ] && [ "$seven_int" -gt "$max_pct" ] 2>/dev/null && max_pct="$seven_int"
  if [ "$max_pct" -ge 80 ]; then
    usage_color="41;97"   # white on red
  elif [ "$max_pct" -ge 50 ]; then
    usage_color="43;30"   # black on yellow
  else
    usage_color="45;97"   # white on magenta
  fi
  seg_usage="${esc}[${usage_color}m  ${usage_text} ${esc}[0m"
fi

printf '%s' "${seg_time}${seg_user}${seg_cwd}${seg_git}${seg_usage}"
