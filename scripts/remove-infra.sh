#!/bin/bash -xe
STACK_NAME=awslambdasample
REGION=us-east-1
CLI_PROFILE=deeep08

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --profile $CLI_PROFILE --query "Account" --output text)

WEBSITE_BUCKET="$STACK_NAME-website-$REGION-$AWS_ACCOUNT_ID"

aws --profile $CLI_PROFILE s3 rm s3://$WEBSITE_BUCKET/index.html
aws --profile $CLI_PROFILE s3 rm s3://$WEBSITE_BUCKET/error.html