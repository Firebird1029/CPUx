#!/usr/bin/env bash

### Script Information & Credits
##############################################################################
# CyberPatriot Ubuntu executables
# Main Script
# main.sh

# Usage:
# sudo su
# ./main.sh

# Based on a template by BASH3 Boilerplate v2.1.0
# http://bash3boilerplate.sh/#authors

# The MIT License (MIT)
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.

### Intro Screen
##############################################################################

# From b3bp:
# Command-line options. This defines the usage page, and is used to parse CLI options and defaults from.
# The parsing is unforgiving so be precise in your syntax.
# - A short option must be preset for every long option; but every short option need not have a long option.
# - `--` is respected as the separator between options and arguments.
# - We do not bash-expand defaults, so setting '~/app' as a default will not resolve to ${HOME}.
#   You can use bash variables to work around this (so use ${HOME} instead).

read -r -d '' __usage <<-'EOF' || true # exits non-zero when EOF encountered
  -d --debug       Enable debug mode
  -h --help        Display this help page
  -n --no-color    Disable color output
  -s --safe-mode   Enable safe mode
  -v               Enable verbose mode, print script as it is executed
EOF

read -r -d '' __helptext <<-'EOF' || true # exits non-zero when EOF encountered
  
EOF
# Written by Brandon Yee and Jason Tay. Started on November 23, 2016, for Punahou School's CyberPatriot Club.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/b3bp_main.sh"

### Command-line Argument Switches
##############################################################################

# Debug Mode
if [ "${arg_d}" = "1" ]; then
  set -o xtrace
  LOG_LEVEL="7"
fi

# Verbose Mode
if [ "${arg_v}" = "1" ]; then
  set -o verbose
fi

# No Color Mode
if [ "${arg_n}" = "1" ]; then
  NO_COLOR="true"
fi

# Help Mode
if [ "${arg_h}" = "1" ]; then
  # Help exists with code 1
  help "Help using ${0}"
fi


### Validation (Error out if the things required for your script are not present.)
##############################################################################

# [ -z "${arg_f:-}" ] && help "Setting a filename with -f or --file is required"
[ -z "${LOG_LEVEL:-}" ] && emergency "Cannot continue without LOG_LEVEL. "

### Exit Trap
##############################################################################

function cleanup_before_exit () {
  info "Cleaning up. Done."
}
trap cleanup_before_exit EXIT

### Pre-Program Debugging
##############################################################################

debug "__file: ${__file}"
debug "__dir: ${__dir}"
debug "__base: ${__base}"
debug "OSTYPE: ${OSTYPE}"

debug "arg_d: ${arg_d}"
debug "arg_v: ${arg_v}"
debug "arg_h: ${arg_h}"

# All of these go to STDERR, so you can use STDOUT for piping machine readable information to other software
# debug "Info useful to developers for debugging the application, not useful during operations."
# info "Normal operational messages - may be harvested for reporting, measuring throughput, etc. - no action required."
# notice "Events that are unusual but not error conditions - might be summarized in an email to developers or admins to spot potential problems - no immediate action required."
# warning "Warning messages, not an error, but indication that an error will occur if action is not taken, e.g. file system 85% full - each item must be resolved within a given time. This is a debug message"
# error "Non-urgent failures, these should be relayed to developers or admins; each item must be resolved within a given time."
# critical "Should be corrected immediately, but indicates failure in a primary system, an example is a loss of a backup ISP connection."
# alert "Should be corrected immediately, therefore notify staff who can fix the problem. An example would be the loss of a primary ISP connection."
# emergency "A \"panic\" condition usually affecting multiple apps/servers/sites. At this level it would usually notify all tech staff on call."

### CHECKLIST: Users
##############################################################################

info "Starting Users phase."
# source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/users.sh"

info "Change sudo password:"
passwd

info "Finished Users phase."

### CHECKLIST: Security
##############################################################################

info "Starting Security phase."
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/security.sh"

info "Setting up firewall and securing homes."
setupFirewall
secureHomes

info "Disabling guest account."
disableGuest

info "Changing password age."
changePasswordAge

info "Finished Security phase."


