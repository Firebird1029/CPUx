#!/usr/bin/env bash
# Sourcer

# Sources
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/functions/update.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/functions/users.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/functions/security.sh"

echo -n "Enter the name of the function you want to run: "
read funcToRun

${funcToRun}