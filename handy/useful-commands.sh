# Execute script for each row of a list e.g execute kubectl commands for each namespace
k get ns | awk '{print $1}' | while read ns; do echo "checking for ns $ns"; k -n $ns get statefulsets.apps etcd-main -o json | jq '.spec.template.spec.containers[].resources' ;  done

# patch the status of a kubernetes resource.
# - Here: patch the status of the Infrastructure resource to not contain the error code any more
# - use "k proxy &"
curl --location --request PATCH 'http://localhost:8001/apis/extensions.gardener.cloud/v1alpha1/namespaces/shoot--d060239--copy/infrastructures/copy/status' \
--header 'Content-Type: application/merge-patch+json' \
--data-raw '{
   "status":{
      "lastError": {
          "codes": []
      }
   }
}'