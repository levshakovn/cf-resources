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
  echo "Bucket $BUCKET_NAME is already deleted."
else
  echo "Emptying the bucket $BUCKET_NAME..."
  # Delete all objects and versions in the bucket
  aws s3api delete-objects \
      --bucket "$BUCKET_NAME" \
      --delete "$(aws s3api list-object-versions --bucket "$BUCKET_NAME" | jq -M '{Objects: [.["Versions","DeleteMarkers"][] | {Key: .Key, VersionId: .VersionId}], Quiet: false}')"

  echo "Bucket $BUCKET_NAME emptied."
fi

# List resources to be deleted
echo "Resources to be deleted:"
aws cloudformation list-stack-resources \
    --stack-name "$STACK_NAME" \
    --region "$AWS_REGION" \
    | jq '.StackResourceSummaries[] | {ResourceType, name: .PhysicalResourceId}'

# Start stack deletion
echo "Deleting stack $STACK_NAME..."
aws cloudformation delete-stack \
    --stack-name "$STACK_NAME" \
    --region "$AWS_REGION"

# Monitor stack deletion status
while true; do
  STATUS=$(check_stack_status)
  echo "Current status: $STATUS"
  
  if [[ "$STATUS" == "DELETE_COMPLETE" ]]; then
    echo "Stack $STACK_NAME deletion is complete."
    break
  elif [[ "$STATUS" == *"FAILED"* || "$STATUS" == "DELETE_FAILED" ]]; then
    echo "Error: Stack deletion failed with status $STATUS."
    exit 1
  fi

  sleep 30
done
