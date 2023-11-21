#!/bin/bash

#https://aws.amazon.com/premiumsupport/knowledge-center/troubleshoot-dependency-error-delete-vpc/

analyze_aws_vpc_dependencies(){
  if [[ -z "$1" ]]; then
      echo "need to supply VPC ID"
      return
  fi

  vpc=$1
  aws ec2 describe-internet-gateways --filters 'Name=attachment.vpc-id,Values='$vpc | grep InternetGatewayId
  aws ec2 describe-subnets --filters 'Name=vpc-id,Values='$vpc | grep SubnetId
  aws ec2 describe-route-tables --filters 'Name=vpc-id,Values='$vpc | grep RouteTableId
  aws ec2 describe-network-acls --filters 'Name=vpc-id,Values='$vpc | grep NetworkAclId
  aws ec2 describe-vpc-peering-connections --filters 'Name=requester-vpc-info.vpc-id,Values='$vpc | grep VpcPeeringConnectionId
  aws ec2 describe-vpc-endpoints --filters 'Name=vpc-id,Values='$vpc | grep VpcEndpointId
  aws ec2 describe-nat-gateways --filter 'Name=vpc-id,Values='$vpc | grep NatGatewayId
  aws ec2 describe-security-groups --filters 'Name=vpc-id,Values='$vpc | grep GroupId
  aws ec2 describe-instances --filters 'Name=vpc-id,Values='$vpc | grep InstanceId
  aws ec2 describe-vpn-connections --filters 'Name=vpc-id,Values='$vpc | grep VpnConnectionId
  aws ec2 describe-vpn-gateways --filters 'Name=attachment.vpc-id,Values='$vpc | grep VpnGatewayId
  aws ec2 describe-network-interfaces --filters 'Name=vpc-id,Values='$vpc | grep NetworkInterfaceId

  # elastic IPS are a global (account-level) resource that can be attached to any NAT gateway,
  # network interface or instance in any VPC in the account
  # aws ec2 describe-addresses --filters  'Name=tag:kubernetes.io/cluster/shoot--d060239--garden,Values=1' | jq
}
