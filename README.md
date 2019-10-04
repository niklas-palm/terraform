# Terraform samples

This repo contains some terraform samples for creating various architectures on AWS.

## Usage

### Configure

Usage of these samples requires aws credentials for a "default" account stored locally inside ~./aws. 

To configure with the aws-cli, Run
```bash
aws configure
``` 
and follow the instructions.

### Terraform

To use any of the example architectures, navigate to the relevant folder and Run

```bash
terraform init
terraform apply -auto-approve
``` 

To shut everything down, run

```bash
terraform destroy -auto-approve
``` 


---

## Samples

### /ec2_lb_web
Creates a VPC in two AZs with one public and one private subnet in each, with a loadbalancer directing trafic to an autoscaling group, where at least two instances are running.