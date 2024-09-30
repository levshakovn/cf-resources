#!/bin/bash

# Load variables
source vars

# Function to check the stack status
check_stack_status() {
  aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -r .Stacks[0].StackStatus
}

# Check if the bucket exists
BUCKET_STATUS=$(aws s3api head-bucket --bucket "$BUCKET_NAME" 2>&1)

if echo "$BUCKET_STATUS" | grep -q 'Not Found'; then
  echo "$(date +%H:%M:%s) -- Bucket $BUCKET_NAME is already deleted."
else
  echo "Emptying the bucket $BUCKET_NAME..."
  # Delete all objects and versions in the bucket
  aws s3api delete-objects \
      --bucket "$BUCKET_NAME" \
      --delete "$(aws s3api list-object-versions --bucket "$BUCKET_NAME" | jq -r --arg key "key-value" '{Objects: [.Versions[] | {Key, VersionId}], Quiet: false}')"

  echo "$(date +%H:%M:%s) -- Bucket $BUCKET_NAME emptied."
fi

# List resources to be deleted
echo "$(date +%H:%M:%s) -- Resources to be deleted:"
aws cloudformation list-stack-resources \
    --stack-name "$STACK_NAME" \
    --region "$AWS_REGION" \
    | jq '.StackResourceSummaries[] | {ResourceType, name: .PhysicalResourceId}'

# Start stack deletion
echo "$(date +%H:%M:%s) -- Deleting stack $STACK_NAME..."
aws cloudformation delete-stack \
    --stack-name "$STACK_NAME" \
    --region "$AWS_REGION"

# Monitor stack deletion status
while true; do
  STATUS=$(check_stack_status)
  echo "$(date +%H:%M:%s) -- Current status: $STATUS"
  
  if [[ "$STATUS" == "DELETE_COMPLETE" || -z "$STATUS"  ]]; then
    echo "$(date +%H:%M:%s) -- Stack $STACK_NAME deletion is complete."
    break
  elif [[ "$STATUS" == *"FAILED"* || "$STATUS" == "DELETE_FAILED" ]]; then
    echo "$(date +%H:%M:%s) -- Error: Stack deletion failed with status $STATUS."
    exit 1
  fi

  sleep 30
done
