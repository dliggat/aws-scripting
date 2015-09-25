# AWS-Scripting

[![Build Status](https://travis-ci.org/dliggat/aws-scripting.svg?branch=master)](https://travis-ci.org/dliggat/aws-scripting)

Various scripts for spinning up AWS infrastructure.

## Cloud Formation

### Create Stack

    cd cloud-formation
    aws s3 sync . s3://dliggat-cf --delete
    aws cloudformation create-stack --stack-name dliggat-nginx \
                                    --template-url https://s3-us-west-2.amazonaws.com/dliggat-cf/static-nginx.template

### Delete Stack

    aws cloudformation delete-stack --stack-name dliggat-nginx

### Create with Parameters

    aws cloudformation create-stack --stack-name dliggat-nginx \
                                    --template-url https://s3-us-west-2.amazonaws.com/dliggat-cf/static-nginx.template \
                                    --parameters ParameterKey=SSHKey,ParameterValue=gsg-keypair

### Update Stack

Added `msyql` to the yum section => update installed it. (Note: parameters still need to be specified if they were overridden on creation).

    aws cloudformation update-stack --stack-name dliggat-nginx \
                                    --template-url https://s3-us-west-2.amazonaws.com/dliggat-cloud-formation/static-nginx.template \
                                    --parameters ParameterKey=SSHKey,ParameterValue=gsg-keypair

