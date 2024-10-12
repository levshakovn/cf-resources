#!/bin/bash
set -e


TASK_NUM="3"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"


source "$SCRIPT_DIR/common/setup.sh"
source "$SCRIPT_DIR/common/cf.sh"
source "$SCRIPT_DIR/common/ec2.sh"
source "$SCRIPT_DIR/common/sts.sh"

get_current_aws_region
get_current_user
get_postfix

STACK_NAME="task-$TASK_NUM-${POSTFIX}"

# Save variables to a file for later use
cat <<EOL > "$SCRIPT_DIR/task_$TASK_NUM/vars"
STACK_NAME="$STACK_NAME"
AWS_REGION=$AWS_REGION
EOL


echo "$(date +%H:%M:%S) -- User $AWS_USER is creating stack $STACK_NAME in region $AWS_REGION..."

# Create CloudFormation stack
aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --template-body "file://$SCRIPT_DIR/task_$TASK_NUM/stack.yaml" \
    --capabilities CAPABILITY_IAM \
    --parameters "ParameterKey=ImageAMI,ParameterValue=$IMAGE_AMI" \
    --region "$AWS_REGION" > /dev/null

monitor_stack_status


echo "$(date +%H:%M:%S) -- All good! You can start with your task now."