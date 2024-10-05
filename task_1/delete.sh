#!/bin/bash

# Load variables
source vars

source ../common/setup.sh
source ../common/cf.sh
source ../common/s3.sh


check_and_set_variable "$STACK_NAME"
check_and_set_variable "$BUCKET_NAME"
check_and_set_variable "$AWS_REGION"

clear_bucket $BUCKET_NAME

list_resources

delete_stack

monitor_stack_status
