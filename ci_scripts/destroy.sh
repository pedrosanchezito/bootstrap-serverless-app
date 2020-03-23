#!/bin/sh

ENV="staging prod"

for feature in $(find /builds/julien-j/bootstrap-serverless-app/bundles/features/ -maxdepth 1 -type d)
do if [[ ${feature} != "/builds/julien-j/bootstrap-serverless-app/bundles/features/" ]]
then
  cd ${feature}
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}"
  for env in ${ENV}
    do
      echo "############## ENV SELECTED: ${env}"
      terraform workspace select ${env}
      retry=1
      if ! terraform destroy -auto-approve && [[ ${retry} -gt 0 ]]
      then
      	terraform destroy -auto-approve
       	retry=0
      fi
    done
fi
done

for shared in $(find /builds/julien-j/bootstrap-serverless-app/bundles/shared/ -maxdepth 1 -type d)
do if [[ ${shared} != "/builds/julien-j/bootstrap-serverless-app/bundles/shared/" ]]
then
  cd ${shared}
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}"
  for env in ${ENV}
    do
      echo "############## ENV SELECTED: ${env}"
      terraform workspace select ${env}
      retry=1
      if ! terraform destroy -auto-approve && [[ ${retry} -gt 0 ]]
      then
      	terraform destroy -auto-approve
       	retry=0
      fi
    done
fi
done