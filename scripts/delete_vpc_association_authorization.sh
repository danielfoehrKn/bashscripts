# TODO:
#  1) add ability to pipe VPC IDs

declare -a arr=(
"vpc-6987c60d"
"vpc-617a3b05"
"vpc-74431210"
"vpc-ea07468e"
)

hostedZone="/hostedzone/Z082842030A5FP7WK1CGR"
vpcRegion="us-gov-west-1"

value=1
authorizations=($(aws route53 list-vpc-association-authorizations --hosted-zone-id $hostedZone | grep "VPCId"))
for auth in "${authorizations[@]}"
do
  if [ $(( $value % 2 )) -eq 0 ] ; then
    to_delete=$(echo $auth | sed 's/"//')
    to_delete=$(echo $to_delete | sed 's/"//')
    to_delete=$(echo $to_delete | sed 's/,//')

    delete_authorization=true
    for vpc in "${arr[@]}"
    do
      if [ "$to_delete" == "$vpc" ] ; then
        echo "should not delete authorization for vpc $to_delete"
        delete_authorization=false
      fi
    done

    if [ $delete_authorization == true ]; then
      echo "deleting authorization for vpc $to_delete"
      aws route53 delete-vpc-association-authorization --hosted-zone-id $hostedZone --vpc VPCRegion=$vpcRegion,VPCId="$to_delete"
    fi
  fi
  let value=value+1
done