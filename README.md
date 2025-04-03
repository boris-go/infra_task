# Infrastructure deployment task

## NGINX Demo Application Terraform Deployment

This repository contains Terraform code to deploy the [nginxdemos/hello](https://hub.docker.com/r/nginxdemos/hello/) Docker container in a highly available, secure infrastructure on AWS.

## Architecture Overview

This deployment creates a highly available, secure infrastructure with the following components:

- VPC with public and private subnets across two availability zones
- Application Load Balancer (ALB) to distribute traffic
- ECS Fargate service for running containers
- Auto-scaling based on CPU utilization
- Bastion host for secure SSH access
- NAT Gateways for outbound internet connectivity from private subnets
- CloudWatch logging for ECS tasks
- IAM roles with least privilege

## Prerequisites

1. AWS account with appropriate permissions
2. Terraform installed (v1.0.0 or newer)
3. AWS CLI configured
4. SSH key pair for bastion host access

## Repository Structure

```
.
├── alb.tf           # Application Load Balancer configuration
├── backend.tf       # Terraform backend configuration 
├── bastion.tf       # Bastion host for SSH access
├── ecs.tf           # ECS cluster, task definition, and service
├── main.tf          # Provider and version constraints
├── outputs.tf       # Output values
├── provider.tf      # AWS provider configuration
├── security.tf      # Security groups and IAM roles
├── variables.tf     # Input variables
└── vpc.tf           # VPC, subnets, and networking components
```

## Deployment Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Create SSH Key Pair (if you don't have one already)

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/bastion_key
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Set Variables

Create a `terraform.tfvars` file with your specific configuration:

```hcl
project_name    = "nginx-demo"
aws_region      = "eu-north-1"
ssh_allowed_ips = ["YOUR-IP-ADDRESS/32"]  # Replace with your IP address
ssh_public_key  = "ssh-rsa AAAA..."       # Content of your public key file
```

Alternatively, you can pass them via command line:

```bash
terraform apply -var="ssh_public_key=$(cat ~/.ssh/bastion_key.pub)" -var="ssh_allowed_ips=[\"YOUR-IP-ADDRESS/32\"]"
```

### 5. Review and Apply Configuration

```bash
terraform plan
terraform apply
```

### 6. Access the Application

After successful deployment, Terraform will output:
- ALB DNS name: Use this URL http://<alb_dns_name> to access the NGINX demo application
- Bastion host public IP: Use this to SSH into the bastion host

```bash
# Example to SSH to the bastion host
ssh -i ~/.ssh/bastion_key ec2-user@$(terraform output -raw bastion_public_ip)
```

## Security Features

1. **Network Segmentation**:
   - Web application runs in private subnets
   - Only the ALB is publicly accessible on ports 80/443
   - Bastion host is the only SSH entry point

2. **Security Groups**:
   - ALB: Accepts HTTP/HTTPS traffic from the internet
   - ECS Tasks: Accept traffic only from the ALB
   - Bastion: Accepts SSH only from specified IP addresses

3. **IAM Roles**:
   - ECS task execution role with minimal permissions

## Customization Options

### Scaling Parameters

Modify these variables to adjust auto-scaling:
- `service_min_count`: Minimum number of tasks (default: 2)
- `service_max_count`: Maximum number of tasks (default: 4)

### Container Resources

Modify these variables to adjust container resources:
- `container_cpu`: CPU units (default: 256)
- `container_memory`: Memory in MiB (default: 512)

### HTTPS Support

To enable HTTPS:

1. Uncomment the HTTPS listener and ACM certificate sections in `alb.tf`
2. Set these variables:
   ```hcl
   enable_https = true
   domain_name  = "yourdomain.com"
   ```
3. Add DNS validation for your ACM certificate

## Cleanup

To remove all resources:

```bash
terraform destroy
```

## Additional Security Recommendations

1. **Enable AWS WAF** on the ALB to protect against common web exploits
2. **Implement VPC Flow Logs** to monitor network traffic
3. **Set up AWS GuardDuty** for threat detection
4. **Enable ALB Access Logs** to capture detailed request information
5. **Enable HTTP to HTTPS redirection** once HTTPS is configured