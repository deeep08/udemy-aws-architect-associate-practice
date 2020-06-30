#!/bin/bash -xe
STACK_NAME=awslambdasample
REGION=us-east-1
CLI_PROFILE=deeep08

DOMAIN=deeep08.com
SUBDOMAIN=$STACK_NAME

WEBSITE_BUCKET="$SUBDOMAIN.$DOMAIN"

# Empty the website bucket
echo -e "\n\n=========== Emptying website bucket ==========="
aws --profile $CLI_PROFILE s3 rm s3://$WEBSITE_BUCKET/index.html
aws --profile $CLI_PROFILE s3 rm s3://$WEBSITE_BUCKET/error.html

# Delete the website stack
echo -e "\n\n=========== Deleting the website stack ==========="
aws cloudformation delete-stack \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME