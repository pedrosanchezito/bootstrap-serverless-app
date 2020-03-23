#!/bin/sh

for shared in $(find /builds/${PROJECT_PATH}/bundles/shared/ -maxdepth 1 -type d)
do if [[ ${shared} != "/builds/${PROJECT_PATH}/bundles/shared/" ]]
then
  cd ${shared}
  echo "############# VALIDATING ${shared} ..."
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}"
  terraform validate
  if [[ ${?} != 0 ]]
  then exit 1
  fi
fi
done

for feature in $(find /builds/${PROJECT_PATH}/bundles/features/ -maxdepth 1 -type d)
do if [[ ${feature} != "/builds/${PROJECT_PATH}/bundles/features/" ]]
then
  cd ${feature}
  echo "############# VALIDATING ${feature} ..."
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}"
  terraform validate
  if [[ ${?} != 0 ]]
  then exit 1
  fi
fi
done