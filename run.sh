#!/bin/bash

# Check if the number of arguments is exactly 2
if [ "$#" -ne 2 ]; then
    echo "Error: You need to provide exactly 2 arguments."
    echo "Usage: ./run.sh <task number> <create/delete>"
    exit 1
fi

# Assign the arguments to variables
TASK_NUMBER="$1"
ACTION="$2"

# Run different scripts based on the arguments
echo "Running $ACTION script for task number $TASK_NUMBER"

chmod +x "./task_${TASK_NUMBER}/${ACTION}.sh"

"./task_${TASK_NUMBER}/${ACTION}.sh"

