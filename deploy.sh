#!/bin/bash
#
# Script to deploy and delete cloudformation stack for webserver
# 
# Usage deploy.sh <action>

set -euo pipefail

# Creates the infrastructure stack -- starting with VPC
up()
{
    echo " Creating stacks for Apache webserver..."
    aws cloudformation "create-stack" \
        --stack-name "ApacheWS-Cfn-vpc" \
        --template-body file://`pwd`/vpc.yaml 
    local result_vpc=$?

    if [ "${result_vpc}" -eq "0" ]; then
      aws cloudformation wait "stack-create-complete" --stack-name "ApacheWS-Cfn-vpc"
      create_ec2
    fi
    
}
# Triggers the EC2 instance creation 
create_ec2()
{
  aws cloudformation "create-stack" \
          --stack-name "ApacheWS-Cfn-ec2" \
          --template-body file://`pwd`/ec2.yaml \
          --capabilities "CAPABILITY_NAMED_IAM" 
    local result_ec2=$?

    if [ "${result_ec2}" -eq "0" ]; then
      echo "Waiting for stack create to complete..."
      aws cloudformation wait "stack-create-complete" --stack-name "ApacheWS-Cfn-ec2"
      echo "stack create complete."
    fi 
}
# Deletes the stacks-- starting with EC2 
down()
{
    aws cloudformation delete-stack \
        --stack-name "ApacheWS-Cfn-ec2" 
    local result_ec2_delete=$?
    if [ "${result_ec2_delete}" -eq "0" ]; then
      aws cloudformation wait "stack-delete-complete" --stack-name "ApacheWS-Cfn-ec2"
      delete_vpc
    fi 
}
# Deletes the VPC stack
delete_vpc()
{
  aws cloudformation delete-stack \
        --stack-name "ApacheWS-Cfn-vpc"
  local result_vpc_delete=$?
    if [ "${result_vpc_delete}" -eq "0" ]; then
      echo "Waiting for stack delete to complete..."
      aws cloudformation wait "stack-delete-complete" --stack-name "ApacheWS-Cfn-vpc"
      echo "stack delete complete"
    fi
}

main ()
{
    local action="$1"
    if [ "$#" -ne 1 ]; then
      echo "Inavlid number of parameters"
      exit 1
    fi


    #verify the action is available for execution
    available_actions=(up \
                       down)
    
    echo ${action}
    if [[ ! " ${available_actions[@]} " =~ " ${action} " ]]; then
      echo "Invalid action"
      echo "Available actions: ${available_actions[*]}"
      exit 1
    fi 
    
    #Perform requested action
    "${action}"
}

main "$@"
