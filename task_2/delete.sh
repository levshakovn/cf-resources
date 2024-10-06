#!/bin/bash
set -e

SCRIPT_DIR="$(dirname "$(realpath "$0")")"



# Load variables
source "$SCRIPT_DIR/task_2/vars"

source "$SCRIPT_DIR/common/setup.sh"
source "$SCRIPT_DIR/common/cf.sh"
source "$SCRIPT_DIR/common/s3.sh"


check_and_set_variable "STACK_NAME"
check_and_set_variable "SRC_BUCKET_NAME"
check_and_set_variable "DEST_BUCKET_NAME"
check_and_set_variable "AWS_REGION"

clear_bucket $SRC_BUCKET_NAME
clear_bucket $DEST_BUCKET_NAME

list_resources

delete_stack

monitor_stack_status
