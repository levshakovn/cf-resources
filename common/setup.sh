get_current_aws_region () {
    current_region="${AWS_REGION:-$AWS_DEFAULT_REGION}"

    if [ -z "$current_region" ]; then
        current_region="us-east-1"
    fi

    read -p "Is $current_region the correct AWS region? (y/n): " confirm

    # If not correct, prompt for a new region
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        read -p "Please enter the correct AWS region: " new_region
        current_region="$new_region"
    fi
    
    export AWS_REGION="$current_region"
}

get_postfix () {
    export POSTFIX=$(date +%Y%m%d-%Hh-%s)
}

check_and_set_variable () {
    VAR_NAME=$1
    if [ -z "${!VAR_NAME}" ]; then
        echo "$VAR_NAME is not set. Please enter a value for $VAR_NAME:"
        read USER_INPUT
        export $VAR_NAME="$USER_INPUT"
        echo "$VAR_NAME has been set to '$USER_INPUT'."
    else
        echo "$VAR_NAME ='${!VAR_NAME}'"
    fi
}