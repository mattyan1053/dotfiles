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

# Color segments (matching the original PS1 style)
# Segment: time (black on white)
seg_time="\e[30;47m  ${time_str} \e[0m"
# Segment: user@host (white on blue)
seg_user="\e[37;44m ${user}@${host} \e[0m"
# Segment: cwd (white on red)
seg_cwd="\e[00;41m  ${cwd} \e[0m"

if [ -n "$git_branch" ]; then
  # Segment: git branch (black on yellow)
  seg_git="\e[30;43m  ${git_branch} \e[0m"
  printf "${seg_time}${seg_user}${seg_cwd}${seg_git}"
else
  printf "${seg_time}${seg_user}${seg_cwd}"
fi
