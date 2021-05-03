Welcome to my example repo for your consideration.
=========

I have herein, two folders containing code demonstrating some Ansible/YAML/JSON/aws-cli/CloudFormation and another folder deomstrating some raw PowerShell. You may notice that some files, variables, and references are missing. 

This is deliberate. 

This code is not meant to be run in any specific environment, but merely to be referenced.

Ansible & EC2 Folder
-------------

The content here is focused on Ansible scripts written in YAML to perform various tasks on EC2 instances. Some of the content is written in YAML and take the form of modules using Ansible's native capabilities, while others are utilizing PowerShell (typically for the things performed on the box) while others still are in AWS CLI format with an output to json. There's also a basic CloudFormation template that one could use to deploy a stack to create an EC2 instance (assuming the variables were supplied). 

This is just a small sampling of code as the bulk of what I have written was for my employer and written on the job and therefore cannot be shared. 

PowerShell Folder
----------
In the PowerShell folder is some raw powershell to peruse. Not for ec2 deployment, but more for just day-to-day work in a VMware environment. It's again hard to display my code as most of it was written on the job and is specific to our enivornment, but please peruse this sampling.
