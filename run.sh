#!/bin/bash
set -e

# Check if the number of arguments is exactly 2
if [ "$#" -ne 2 ]; then
    echo "Error: You need to provide exactly 2 arguments."
    echo "Usage: ./run.sh <task number> <create/delete>"
    exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Assign the arguments to variables
TASK_NUMBER="$1"
ACTION="$2"

# Run different scripts based on the arguments
echo "Running $ACTION script for task number $TASK_NUMBER"

chmod +x "$SCRIPT_DIR/task_${TASK_NUMBER}/${ACTION}.sh"

source "$SCRIPT_DIR/task_${TASK_NUMBER}/${ACTION}.sh"

