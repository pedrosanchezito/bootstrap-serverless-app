#!/bin/sh

ENV="staging prod"
FOLDERPATH=$1

for feature in $(find $FOLDERPATH/features/ -mindepth 1 -maxdepth 1 -type d)
do
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}" $feature
  for env in ${ENV}
    do
      echo "############## ENV SELECTED: ${env}"
     terraform workspace select ${env}  $feature
      retry=1
      if ! terraform destroy -auto-approve $feature && [[ ${retry} -gt 0 ]]
      then
      	terraform destroy -auto-approve $feature
       	retry=0
      fi
    done
done

for shared in $(find $FOLDERPATH/shared/ -mindepth 1 -maxdepth 1 -type d)
do
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}" $shared
  for env in ${ENV}
    do
      echo "############## ENV SELECTED: ${env}"
      terraform workspace select ${env} $shared
      retry=1
      if ! terraform destroy -auto-approve $shared && [[ ${retry} -gt 0 ]]
      then
      	terraform destroy -auto-approve $shared
       	retry=0
      fi
    done
done