create_aws_bastion(){
    if [[ -z "$1" ]]; then
      echo "need to supply VPC ID"
      return
  fi
  vpc=$1

  aws ec2 create-security-group --group-name <security-group-name> --description ssh-access --vpc-id $vpc
}


