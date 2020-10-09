#!/bin/sh

ENV=$1
FOLDERPATH=$2

for shared in $(find $FOLDERPATH/shared/ -mindepth 1 -maxdepth 1 -type d)
do
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}" $shared
  terraform workspace select $ENV $shared || terraform workspace new $ENV && terraform workspace select $ENV $shared
  terraform apply -auto-approve $shared
  echo "############# ${shared} completed"
done

for feature in $(find $FOLDERPATH/features/ -mindepth 1 -maxdepth 1 -type d)
do
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}" $feature
  terraform workspace select $ENV $feature || terraform workspace new $ENV && terraform workspace select $ENV $feature
  terraform apply -auto-approve $feature
  echo "############# ${feature} completed"
done