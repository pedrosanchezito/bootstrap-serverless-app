#!/bin/sh

FOLDERPATH=$1

for shared in $(find $FOLDERPATH/shared/ -mindepth 1 -maxdepth 1 -type d)
do
  echo "############# VALIDATING ${shared} ..."
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}" $shared
  terraform validate $shared
done

for feature in $(find $FOLDERPATH/features/ -mindepth 1 -maxdepth 1 -type d)
do
  echo "############# VALIDATING ${feature} ..."
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}" $feature
  terraform validate $feature
done