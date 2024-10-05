# STACK_NAME
check_stack_status () {
    aws cloudformation describe-stacks --stack-name "$STACK_NAME" | jq -r .Stacks[0].StackStatus
}

# STACK_PARAMS
create_stack () {
    _STASK_PARAMS=$1
    # Inform the user of the stack creation process
    echo "$(date +%H:%M:%S) -- User $AWS_USER is creating stack $STACK_NAME in region $AWS_REGION..."

    # Create CloudFormation stack
    aws cloudformation create-stack \
        --stack-name "$STACK_NAME" \
        --template-body "file://$SCRIPT_DIR/stack.yaml" \
        --capabilities CAPABILITY_IAM \
        --parameters $_STASK_PARAMS \
        --region "$AWS_REGION" > /dev/null
}

monitor_stack_status () {
    # Loop to monitor the stack creation status every 30 seconds
    while true; do
        _STATUS=$(check_stack_status)
        echo "$(date +%H:%M:%S) -- Current status: $_STATUS"
    
    if [[ "$_STATUS" == "CREATE_COMPLETE" || "$_STATUS" == "UPDATE_COMPLETE" ]]; then
        echo "$(date +%H:%M:%S) -- Stack creation/update is complete."
        break
    elif [[ "$_STATUS" == "DELETE_COMPLETE" || -z "$_STATUS"  ]]; then
        echo "$(date +%H:%M:%S) -- Stack $STACK_NAME deletion is complete."
        break
    elif [[ "$_STATUS" == *"FAILED"* || "$_STATUS" == "ROLLBACK_COMPLETE" || "$_STATUS" == "DELETE_FAILED" ]]; then
        echo "$(date +%H:%M:%S) -- Error: Stack creation/update/deletion failed with status $_STATUS."
        exit 1
    fi
        sleep 10
    done
}

list_resources () {
    # List resources to be deleted
    echo "$(date +%H:%M:%S) -- Resources to be deleted:"
    aws cloudformation list-stack-resources \
        --stack-name "$STACK_NAME" \
        --region "$AWS_REGION" \
        | jq '.StackResourceSummaries[] | {ResourceType, name: .PhysicalResourceId}'
}

delete_stack () {
    # Start stack deletion
    echo "$(date +%H:%M:%S) -- Deleting stack $STACK_NAME..."
    aws cloudformation delete-stack \
        --stack-name "$STACK_NAME" \
        --region "$AWS_REGION"
}