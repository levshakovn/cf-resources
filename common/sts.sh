get_current_user () {
    tee $(aws sts get-caller-identity | jq -r ".Arn")
}