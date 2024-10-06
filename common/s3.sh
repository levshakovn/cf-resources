upload_file_to_bucket () {
    _BUCKET_NAME=$1
    _FILE_NAME=$2
    _FILE_PATH="$SCRIPT_DIR/task_$3/$_FILE_NAME"
    echo "$(date +%H:%M:%S) -- Uploading $_FILE_PATH to the $_BUCKET_NAME S3 bucket..."
    aws s3api put-object \
        --bucket $_BUCKET_NAME \
        --key $_FILE_NAME \
        --body $_FILE_PATH \
        --content-type "text/html" \
        --region "$AWS_REGION" > /dev/null
}

get_bucket_status () {
    _BUCKET_NAME=$1
    echo $(aws s3api head-bucket --bucket "$_BUCKET_NAME" 2>&1)
}

clear_bucket () {
    _BUCKET_NAME=$1
    _BUCKET_STATUS=$(get_bucket_status "$_BUCKET_NAME")
    _BUCKET_OBJECTS=$(aws s3api list-object-versions --bucket "$_BUCKET_NAME" | jq -e 'has("Versions")')

    # Check if bucket is already deleted
    if echo "$_BUCKET_STATUS" | grep -q 'Not Found'; then
        echo "$(date +%H:%M:%S) -- Bucket $_BUCKET_NAME is already deleted."
    
    # Check if bucket is empty
    elif [ "$_BUCKET_OBJECTS" ]; then
        _OBJECT_VERSIONS=$(aws s3api list-object-versions --bucket "$_BUCKET_NAME" | jq -r '{Objects: [.Versions[] | {Key, VersionId}], Quiet: false}')
        echo "$(date +%H:%M:%S) -- Emptying the bucket $_BUCKET_NAME..."
        
        # Delete all objects and versions in the bucket
        aws s3api delete-objects \
            --bucket "$_BUCKET_NAME" \
            --delete "$_OBJECT_VERSIONS"
        
        echo "$(date +%H:%M:%S) -- Bucket $_BUCKET_NAME emptied."
    else
        echo "$(date +%H:%M:%S) -- Bucket $_BUCKET_NAME is already empty."
    fi
}
