get_current_user () {
    echo $(aws sts get-caller-identity | jq -r ".Arn")
}