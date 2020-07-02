# udemy-aws-architect-associate-practice
AWS Examples from udemy acloudgurus AWS Architect course implemented using Cloud Formation 

Prerequisites
=====================
* Install AWS Cli
* Configure AWS Cli profile by adding access key id and secret access key OR use ```aws configure``` command 

Build
=====================
* NA

Deploy to AWS
=====================
Steps:-
1. Go to scripts folder
2. Change the below parameters inside ```deploy-infra.sh``` as required
    * STACK_NAME - Name of the stack inside cloud formation
    * REGION - AWS Region you want stack and its resources to be deployed
    * CLI_PROFILE - Name of the AWS Cli profile created in Prerequisites
    * API_STAGE_NAME - Name of the stage for API Gateway to be deployed
    * DOMAIN - Your registered domain name
    * SUBDOMAIN
    * BUCKET_DNS_NAME
    * BUCKET_HOSTED_ZONE_ID 
    
        For value of BUCKET_DNS_NAME and BUCKET_HOSTED_ZONE_ID,
        refer to Website Endpoint and Route 53 Hosted Zone ID  respectively
        for the REGION value you specified in the link
        https://docs.aws.amazon.com/general/latest/gr/s3.html#s3_website_region_endpoints
3. Run the below command to deploy the cloud formation stack to AWS 
    ```
    ./deploy-infra.sh
    ```
4. The output of the script displays the URL of the Endpoint to access the created website.
