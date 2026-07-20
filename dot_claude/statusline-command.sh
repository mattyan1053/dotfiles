#!/usr/bin/env bash
# Claude Code statusLine command
# Mirrors the bash PS1 from ~/.bash_prompt:
#   [time] [user@host] [cwd] [git branch]

input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
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

if [ -n "$git_branch" ]; then
  # Segment: git branch (black on yellow)
  seg_git="${esc}[30;43m  ${git_branch} ${esc}[0m"
  printf '%s' "${seg_time}${seg_user}${seg_cwd}${seg_git}"
else
  printf '%s' "${seg_time}${seg_user}${seg_cwd}"
fi
