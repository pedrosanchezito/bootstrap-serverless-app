# AWS serverless app

## Manual actions to execute prior to deployment
### AWS: create a user and manage his permissions
> WARNING: this is not a best practice and will be updated

Create an IAM user in the account that will be used, create and download his access key.

In the user permissions tab, grant him the following policies:
- AWSLambdaFullAccess
- IAMFullAccess
- AmazonS3FullAccess
- AmazonDynamoDFullAccess
- AmazonAPIGatewayAdministrator 

### AWS: create a bucket for TF states
In order to maintain the infrastructure state, Terraform requires a place to host it.
For this project, we will use an AWS S3 bucket.

In the AWS account that will be used to deploy the infrastructure, create a S3 bucket.

### AWS: create a DynamoDB table for TF states lock
In order to avoid concurrent modifications, Terraform has a lock mechanism on its tf states.

In the AWS account that will be used to deploy the infrastructure, create a DynamoDB table 
with "LockID" as Partition key.

### GitLab: setup environment variables
Some environment variables need to be added in your-project/Settings/CI/CD/Variables:

| Variable                      |  Description |
|-------------------------------|--------------|
| AWS_ACCESS_KEY_ID             | The ACCESS KEY ID of the AWS user that will deploy the infratructure |
| AWS_SECRET_ACCESS_KEY         | The SECRET ACCESS KEY associated to the ACCESS KEY ID above |
| TF_VAR_aws_account            | AWS account number used to deploy the infrastructure |
| TF_VAR_aws_region             | AWS region where the infrastructure will be deployed |
| TF_VAR_project_name           | The name of the project for resources tagging purpose |
| TF_VAR_bucket_tfstate_name    | AWS S3 bucket name that will keep all tf states |
| TF_VAR_dynamodb_tfstate_table | AWS DynamoDB table name that will be used to lock Terraform deployments |

## Deployment
### Workflow
Any new merge request will go through Terraform validation process, to control that 
there is no syntax error.

To create / update the staging environment, merge any branch into the `staging` branch

To create / update the prod environment, merge the staging into the `master` branch

To destroy all environments (clean up after testing), merge any branch into `trash`
