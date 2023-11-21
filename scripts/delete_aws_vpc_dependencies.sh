# If there are dependecny issues: go into the Web UI under section `VPC` and delete it. It will show the resources that block it from bein deleted.

# https://github.com/gardener/gardener-extension-provider-aws/blob/63506629da9dc179b2a88645904be9ba8cad664b/test/integration/infrastructure/infrastructure_test.go#L862
#  also delete
# do not delete machines as safeguard
# - the load balancer
# - dhcp options
# - vpc gateway endpoints
# - iam resource bastions
# - iam resource nodes

delete_aws_vpc_dependencies(){
  if [[ -z "$1" ]]; then
      echo "need to supply VPC ID"
      return
  fi

  declare -a arr=(
    $1
  )

    ## now loop through the above array
    for vpc in "${arr[@]}"
    do
       echo "deleting vpc $vpc"


# terminate remaining ec2 instances

# aws ec2 describe-instances --filters Name=vpc-id,Values=vpc-afdad9cb
# aws ec2 terminate-instances --instance-ids i-0192d622b85100cfa

# delete elastic ip attached to nat gateway
allocationID=($(aws ec2 describe-nat-gateways --filter 'Name=vpc-id,Values='$vpc | jq -r '.NatGateways[0].NatGatewayAddresses[0].AllocationId'))
if [ -n "$1" ]; then
  echo "Deleting elastic Ip with allocation id $allocationID!"
  aws ec2 release-address --allocation-id $allocationID
fi

# delete nat gateways (having public ip attached)
      value=1
      gateways=($(aws ec2 describe-nat-gateways --filter 'Name=vpc-id,Values='$vpc | grep NatGatewayId))
      for gat in "${gateways[@]}"
      do
        if [ $(( $value % 2 )) -eq 0 ] ; then
          to_delete=$(echo $gat | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/,//')
          echo "deleting nat gateway $to_delete"
          aws ec2 delete-nat-gateway --nat-gateway-id $to_delete
        fi
        let value=value+1
      done


    sleep 10s

#  detach internet gatway from vpc
    value=1
      gateways=($(aws ec2 describe-internet-gateways --filters 'Name=attachment.vpc-id,Values='$vpc | grep InternetGatewayId))
      for gat in "${gateways[@]}"
      do
        if [ $(( $value % 2 )) -eq 0 ] ; then
          to_delete=$(echo $gat | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/,//')
          echo "detaching internet gateway $to_delete"
          aws ec2 detach-internet-gateway --internet-gateway-id $to_delete --vpc-id $vpc
        fi
        let value=value+1
      done

      #  delete internet gatway
    value=1
      gateways=($(aws ec2 describe-internet-gateways --filters 'Name=attachment.vpc-id,Values='$vpc | grep InternetGatewayId))
      for gat in "${gateways[@]}"
      do
        if [ $(( $value % 2 )) -eq 0 ] ; then
          to_delete=$(echo $gat | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/,//')
          echo "detaching internet gateway $to_delete"
          aws ec2 delete-internet-gateway --internet-gateway-id $to_delete
        fi
        let value=value+1
      done


    # network acls
      value=1
      acl=($(aws ec2 describe-network-acls --filters 'Name=vpc-id,Values='$vpc | grep NetworkAclId))
      for gat in "${acl[@]}"
      do
        if [ $(( $value % 2 )) -eq 0 ] ; then
          to_delete=$(echo $gat | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/,//')
          echo "deleting acl $to_delete"
          aws ec2 delete-network-acl --network-acl-id $to_delete

#         if acl has dependencies: aws ec2 describe-network-interfaces --filters Name=group-id,Values=sg-ff785f99
        fi
        let value=value+1
      done


      # security groups
      value=1
      security=($(aws ec2 describe-security-groups --filters 'Name=vpc-id,Values='$vpc | grep GroupId))
      for gat in "${security[@]}"
      do
        if [ $(( $value % 2 )) -eq 0 ] ; then
          to_delete=$(echo $gat | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/,//')
          echo "deleting security group $to_delete"
          aws ec2 delete-security-group --group-id $to_delete
        fi
        let value=value+1
      done



      # subnet
      value=1
      subnets=($(  aws ec2 describe-subnets --filters 'Name=vpc-id,Values='$vpc | grep SubnetId))
      for gat in "${subnets[@]}"
      do
        if [ $(( $value % 2 )) -eq 0 ] ; then
          to_delete=$(echo $gat | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/,//')
          echo "deleting subnet $to_delete"
          aws ec2 delete-subnet --subnet-id $to_delete
        fi
        let value=value+1
      done

      # RouteTable
      value=1
      routeTables=($(aws ec2 describe-route-tables --filters 'Name=vpc-id,Values='$vpc | grep RouteTableId))
      echo $routeTables
      for gat in "${routeTables[@]}"
      do
        if [ $(( $value % 2 )) -eq 0 ] ; then
          to_delete=$(echo $gat | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/"//')
          to_delete=$(echo $to_delete | sed 's/,//')
          echo "deleting route table $to_delete"
          aws ec2 delete-route-table --route-table-id $to_delete
        fi
        let value=value+1
      done

      # vpc
      aws ec2 delete-vpc --vpc-id $vpc
    done
}