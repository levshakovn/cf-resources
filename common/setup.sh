get_current_aws_region () {
    current_region="${AWS_REGION:-$AWS_DEFAULT_REGION}"

    if [ -z "$current_region" ]; then
        current_region="us-east-1"
    fi

    # Ask the user if the detected region is correct
    echo "Detected AWS region: $current_region"
    read -p "Is this the correct AWS region? (y/n): " confirm

    # If not correct, prompt for a new region
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        read -p "Please enter the correct AWS region: " new_region
        current_region="$new_region"
    fi

    echo "Using AWS region: $current_region"
    
    echo $current_region
}

get_postfix () {
    echo $(date +%Y%m%d-%Hh-%s)
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