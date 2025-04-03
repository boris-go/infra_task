variable "project_name" {
  description = "Name of the project"
  default     = "nginx-demo-test-task"
}

variable "aws_region" {
  description = "AWS region"
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "container_port" {
  description = "Port the container listens on"
  default     = 80
}

variable "container_cpu" {
  description = "CPU units for the container"
  default     = "256"
}

variable "container_memory" {
  description = "Memory for the container (in MiB)"
  default     = "512"
}

variable "service_min_count" {
  description = "Minimum number of tasks to run"
  default     = 2
}

variable "service_max_count" {
  description = "Maximum number of tasks to run"
  default     = 4
}

variable "ssh_allowed_ips" {
  description = "List of CIDR blocks allowed to SSH to bastion"
  type        = list(string)
  default     = ["83.8.35.124/32"] # Change for your IP
}

variable "ssh_public_key" {
  description = "Public SSH key for bastion access"
}

variable "bastion_ami" {
  description = "AMI ID for bastion host"
  default     = "ami-0274f4b62b6ae3bd5" # Amazon Linux 2023 AMI
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  default     = "t3.micro"
}

variable "enable_https" {
  description = "Whether to enable HTTPS"
  type        = bool
  default     = false
}

# variable "domain_name" {
#   description = "Domain name for HTTPS certificate"
#   default     = "your-actual-domain.com"  # Your actual domain name
# }
