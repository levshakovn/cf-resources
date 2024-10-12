get_image_ami () {
    export IMAGE_AMI=$(aws ec2 describe-images --region $AWS_REGION --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" --query "Images | sort_by(@, &CreationDate)[-1].ImageId" --output text)
}