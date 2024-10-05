#!/bin/bash

source ../common/setup.sh
source ../common/cf.sh
source ../common/s3.sh

AWS_REGION=$(get_current_aws_region)
AWS_USER=$(get_current_user)
POSTFIX=$(get_postfix)

STACK_NAME="task-1-${POSTFIX}"
BUCKET_NAME="task-1-${AWS_REGION}-${POSTFIX}"
STACK_PARAMS="ParameterKey=BucketName,ParameterValue=$BUCKET_NAME"
FILE_NAME="index.html"

# Save variables to a file for later use
cat <<EOL > vars
STACK_NAME=$STACK_NAME
BUCKET_NAME=$BUCKET_NAME
AWS_REGION=$AWS_REGION
EOL

create_stack $STACK_PARAMS

monitor_stack_status

upload_file_to_bucket $BUCKET_NAME $FILE_NAME

echo "$(date +%H:%M:%s) -- All good! You can start with your task now."