#!/bin/bash
set -e

SCRIPT_DIR="$(dirname "$(realpath "$0")")"



# Load variables
source "$SCRIPT_DIR/task_4/vars"

source "$SCRIPT_DIR/common/setup.sh"
source "$SCRIPT_DIR/common/cf.sh"


check_and_set_variable "STACK_NAME"
check_and_set_variable "AWS_REGION"

delete_stack

monitor_stack_status
