#!/bin/bash

# Set region, user, and postfix variables
AWS_REGION=$(echo $AWS_DEFAULT_REGION || echo "us-east-1")
AWS_USER=$(aws sts get-caller-identity | jq -r ".Arn")
POSTFIX=$(date +%Y%m%d-%Hh-%s)

# Define stack and bucket names
STACK_NAME="task-1-${POSTFIX}"
BUCKET_NAME="task-1-${AWS_REGION}-${POSTFIX}"

# Save variables to a file for later use
cat <<EOL > vars
STACK_NAME=$STACK_NAME
BUCKET_NAME=$BUCKET_NAME
AWS_REGION=$AWS_REGION
EOL

# Function to check the CloudFormation stack status
check_stack_status() {
  aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -r .Stacks[0].StackStatus
}

# Inform the user of the stack creation process
echo "User $AWS_USER is creating stack $STACK_NAME in region $AWS_REGION..."

# Create CloudFormation stack
aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --template-body file://stack.yaml \
    --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=BucketName,ParameterValue="$BUCKET_NAME" \
    --region "$AWS_REGION"

# Loop to monitor the stack creation status every 30 seconds
while true; do
  STATUS=$(check_stack_status)
  echo "Current status: $STATUS"
  
  if [[ "$STATUS" == "CREATE_COMPLETE" || "$STATUS" == "UPDATE_COMPLETE" ]]; then
    echo "Stack creation/update is complete."
    break
  elif [[ "$STATUS" == *"FAILED"* || "$STATUS" == "ROLLBACK_COMPLETE" || "$STATUS" == "DELETE_FAILED" ]]; then
    echo "Error: Stack creation/update failed with status $STATUS."
    exit 1
  fi

  sleep 30
done

echo "Resources were successfully deployed."

echo "Uploading index.html to the S3 bucket..."
aws s3api put-object \
    --bucket "$BUCKET_NAME" \
    --key index.html \
    --body index.html \
    --content-type "text/html" \
    --region "$AWS_REGION"

echo "All good! You can start with your task now."