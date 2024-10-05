upload_file_to_bucket () {

    echo "$(date +%H:%M:%s) -- Uploading $2 to the $1 S3 bucket..."
    aws s3api put-object \
        --bucket $1 \
        --key $2 \
        --body $2 \
        --content-type "text/html" \
        --region "$AWS_REGION" > /dev/null
}

get_bucket_status () {
    _BUCKET_NAME=$1
    echo $(aws s3api head-bucket --bucket "$_BUCKET_NAME" 2>&1)
}

clear_bucket () {
    _BUCKET_NAME=$1
    _BUCKET_STATUS=$(get_bucket_status $_BUCKET_NAME)
    if echo "$BUCKET_STATUS" | grep -q 'Not Found'; then
        echo "$(date +%H:%M:%s) -- Bucket $_BUCKET_NAME is already deleted."
    else
        echo "Emptying the bucket $_BUCKET_NAME..."
        # Delete all objects and versions in the bucket
        aws s3api delete-objects \
            --bucket "$_BUCKET_NAME" \
            --delete "$(aws s3api list-object-versions --bucket "$_BUCKET_NAME" | jq -r --arg key "key-value" '{Objects: [.Versions[] | {Key, VersionId}], Quiet: false}')"

        echo "$(date +%H:%M:%s) -- Bucket $_BUCKET_NAME emptied."
    fi
}