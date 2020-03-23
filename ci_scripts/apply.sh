#!/bin/sh

if [[ $CI_MERGE_REQUEST_TARGET_BRANCH_NAME = "master" ]]
then ENV="prod"
elif [[ $CI_MERGE_REQUEST_TARGET_BRANCH_NAME = "staging" ]]
then ENV="staging"
fi

for shared in $(find /builds/${PROJECT_PATH}/bundles/shared/ -maxdepth 1 -type d)
do if [[ ${shared} != "/builds/${PROJECT_PATH}/bundles/shared/" ]]
then
  cd ${shared}
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}"
  terraform workspace select $ENV || terraform workspace new $ENV && terraform workspace select $ENV
  terraform apply -auto-approve
  echo "############# ${shared} completed"
fi
done

for feature in $(find /builds/${PROJECT_PATH}/bundles/features/ -maxdepth 1 -type d)
do if [[ ${feature} != "/builds/${PROJECT_PATH}/bundles/features/" ]]
then
  cd ${feature}
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}"
  terraform workspace select $ENV || terraform workspace new $ENV && terraform workspace select $ENV
  terraform apply -auto-approve
  echo "############# ${feature} completed"
fi
done