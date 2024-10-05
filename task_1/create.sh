#!/bin/bash
set -e

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

source "$SCRIPT_DIR/common/setup.sh"
source "$SCRIPT_DIR/common/cf.sh"
source "$SCRIPT_DIR/common/s3.sh"
source "$SCRIPT_DIR/common/sts.sh"

get_current_aws_region
get_current_user
get_postfix

STACK_NAME="task-1-${POSTFIX}"
BUCKET_NAME="task-1-${AWS_REGION}-${POSTFIX}"
STACK_PARAMS="ParameterKey=BucketName,ParameterValue=$BUCKET_NAME"
FILE_NAME="$SCRIPT_DIR/index.html"

# Save variables to a file for later use
cat <<EOL > "$SCRIPT_DIR/vars"
STACK_NAME="$STACK_NAME"
BUCKET_NAME=$BUCKET_NAME
AWS_REGION=$AWS_REGION
EOL


echo "$(date +%H:%M:%s) -- User $AWS_USER is creating stack $STACK_NAME in region $AWS_REGION..."

# Create CloudFormation stack
aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --template-body "file://$SCRIPT_DIR/task_1/stack.yaml" \
    --capabilities CAPABILITY_IAM \
    --parameters $STASK_PARAMS \
    --region "$AWS_REGION" > /dev/null

monitor_stack_status

upload_file_to_bucket $BUCKET_NAME $FILE_NAME

echo "$(date +%H:%M:%s) -- All good! You can start with your task now."