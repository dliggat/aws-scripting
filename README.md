# AWS-Scripting

Various scripts for spinning up AWS infrastructure.

## Cloud Formation

### Create Stack

    cd cloud-formation
    aws s3 sync . s3://dliggat-cf --delete
    aws cloudformation create-stack --stack-name dliggat-nginx --template-url https://s3-us-west-2.amazonaws.com/dliggat-cf/static-nginx.template

### Delete Stack

    aws cloudformation delete-stack --stack-name dliggat-nginx
