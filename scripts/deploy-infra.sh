#!/bin/bash -xe
STACK_NAME=awslambdasample
REGION=us-east-1
CLI_PROFILE=deeep08

# AWS_ACCOUNT_ID=$(aws sts get-caller-identity --profile $CLI_PROFILE --query "Account" --output text)

API_STAGE_NAME="prod"

DOMAIN=deeep08.com
SUBDOMAIN=$STACK_NAME

WEBSITE_BUCKET="$SUBDOMAIN.$DOMAIN"

# For value of BUCKET_DNS_NAME and BUCKET_HOSTED_ZONE_ID,
# refer to Website Endpoint and Route 53 Hosted Zone ID  respectively
# for the REGION value you specified in the link
# https://docs.aws.amazon.com/general/latest/gr/s3.html#s3_website_region_endpoints
BUCKET_DNS_NAME="s3-website-us-east-1.amazonaws.com"
BUCKET_HOSTED_ZONE_ID="Z3AQBSTGFYJSTF"

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
      WebsiteBucketName="$WEBSITE_BUCKET" \
      ApiStageName="$API_STAGE_NAME" \
      Domain="$DOMAIN" \
      SubDomain="$SUBDOMAIN" \
      WebsiteBucketDNSName="$BUCKET_DNS_NAME" \
      WebsiteBucketHostedZoneId="$BUCKET_HOSTED_ZONE_ID"

# If the deploy succeeded, show the DNS name of the created bucket
if [ $? -eq 0 ]; then
  API_GATEWAY_ID=$(aws cloudformation list-exports \
    --profile $CLI_PROFILE \
    --query "Exports[?Name=='ApiGatewayID'].Value" --output text)

  API_GATEWAY_ENDPOINT="https://$API_GATEWAY_ID.execute-api.$REGION.amazonaws.com/$API_STAGE_NAME/"

  sed "s|PUT_API_GATEWAY_ENDPOINT_HERE|$API_GATEWAY_ENDPOINT|g" ../html/index.html > index_tmp.html

  aws --profile $CLI_PROFILE s3 cp index_tmp.html s3://$WEBSITE_BUCKET/index.html
  aws --profile $CLI_PROFILE s3 cp ../html/error.html s3://$WEBSITE_BUCKET
  aws --profile $CLI_PROFILE s3api put-object-acl --bucket $WEBSITE_BUCKET --key index.html --acl public-read
  aws --profile $CLI_PROFILE s3api put-object-acl --bucket $WEBSITE_BUCKET --key error.html --acl public-read

  rm -f index_tmp.html

  aws cloudformation list-exports \
    --profile $CLI_PROFILE \
    --query "Exports[?ends_with(Name, 'Endpoint')].Value"
fi

