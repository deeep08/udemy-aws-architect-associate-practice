#!/bin/bash -xe
STACK_NAME=awslambdasample
REGION=us-east-1
CLI_PROFILE=deeep08

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --profile $CLI_PROFILE --query "Account" --output text)

WEBSITE_BUCKET="$STACK_NAME-website-$REGION-$AWS_ACCOUNT_ID"

# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying main.yml ==========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME \
  --template-file ../templates/main.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
      WebsiteBucketName="$WEBSITE_BUCKET"

aws --profile $CLI_PROFILE s3 cp ../html/index.html s3://$WEBSITE_BUCKET
aws --profile $CLI_PROFILE s3 cp ../html/error.html s3://$WEBSITE_BUCKET
aws --profile $CLI_PROFILE s3api put-object-acl --bucket $WEBSITE_BUCKET --key index.html --acl public-read
aws --profile $CLI_PROFILE s3api put-object-acl --bucket $WEBSITE_BUCKET --key error.html --acl public-read

# If the deploy succeeded, show the DNS name of the created bucket
if [ $? -eq 0 ]; then
  aws cloudformation list-exports \
    --profile $CLI_PROFILE \
    --query "Exports[?ends_with(Name, 'Endpoint')].Value"
fi

