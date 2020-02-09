#!/bin/sh

ENV="staging prod"

for feature in $(find /builds/bootstrap-serverless-webapp/deploy/bundles/features/ -maxdepth 1 -type d)
do if [ ${feature} != "/builds/bootstrap-serverless-webapp/deploy/bundles/features/" ]
then
  cd ${feature}
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}"
  for env in $ENV
    do
      echo "############## ENV SELECTED: ${env}"
      terraform workspace select ${env}
      terraform destroy -auto-approve
      if [ ${?} != 0 ]
      then
        exit 1
      fi
    done
fi
done

for shared in $(find /builds/bootstrap-serverless-webapp/deploy/bundles/shared/ -maxdepth 1 -type d)
do if [ ${shared} != "/builds/bootstrap-serverless-webapp/deploy/bundles/shared/" ]
then
  cd ${shared}
  terraform init -backend-config="region=${TF_VAR_aws_region}" -backend-config="bucket=${TF_VAR_bucket_tfstate_name}" -backend-config="dynamodb_table=${TF_VAR_dynamodb_tfstate_table}"
  for env in $ENV
    do
      echo "############## ENV SELECTED: ${env}"
      terraform workspace select ${env}
      terraform destroy -auto-approve
      if [ ${?} != 0 ]
      then
        exit 1
      fi
    done
fi
done