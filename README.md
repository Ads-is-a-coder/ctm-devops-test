# CTM DevOps Test
## Summary
 This repo houses two Cloudformation templates and a deploy script. These templates create a VPC with functioning internet routes both in private and public settings as well as a second template that defines an ASG ELB and affilated resources. 

## Resources defined to achive the solution;
 VPC 
 NAT Gateway 
 Internet Gateway 
 RouteTables 
 Subnets 
 AutoScaling Group 
 EC2 Launch Configuration
 Elastic Load Balancer
 IAM Roles 
 IAM Instance Profiles 
 Security Groups
 EC2 Instance

## Dependancies 
 - AWS CLI with permissions via a role or AK / SK Combination to run 'aws cloudformation' commands.
 - This code will require the user to have Linux (Bash) environment for the deploy script to work.

## Process
### Create
 Clone the repository to a location of your choice on your computer.
 From your machine with permissions to create resources in your AWS account run the following commands;
  - "cd" into the folder on the local machine.
  - Run "./deploy.sh up" to provision the resources. Please be patient the resource provisioning could take some time, once complete you will see the message "stack create complete".
### Destroy
 Once you are happy with the stacks and no longer require them or the resources run the following command; 
  - Run "./deploy.sh down" to trigger deletion. This could also take long, when complete you will see the message "stack delete complete".

## Considerations 
 This template can accumulate costs with the following resources.
 * The NAT Gateway Devices 
 * The EC2 Instance(s)
 The ASG has been set to use 2 instances although in an HA environment this would be more. Additionally, only 1 NAT GW has been defined but in an a HA environment this would be set to 2. This is due to cost consideration for testing purpose. 

 ## Extra features
 These instances are configured to use the AWS SSM Agent. By defualt all instances that are stood up have the ability to be interacted with using the SSM Agent. This can be done through the website or through the AWS CLI provided the AWS Session Manager Plugin is installed. 
  - aws ssm start-session --target <instanceid>
  In order to facilitate this feature the inbound Security Group allows HTTPS traffic from any source in. In a real world scenario this could easily be fixed using AWS SSM private Endpoints.