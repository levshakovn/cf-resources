get_current_user () {
    export AWS_USER=$(aws sts get-caller-identity | jq -r ".Arn")
}