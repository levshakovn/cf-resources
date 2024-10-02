#!/bin/bash

# Check if the number of arguments is exactly 2
if [ "$#" -ne 2 ]; then
    echo "Error: You need to provide exactly 2 arguments."
    echo "Usage: ./run.sh <task number> <create/delete>"
    exit 1
fi

# Assign the arguments to variables
arg1="$1"
arg2="$2"

# Run different scripts based on the arguments
echo "Running $arg2 script for task number $arg1"

chmod +x "./task_${arg1}/${arg2}.sh"
"./task_${arg1}/${arg2}.sh"

