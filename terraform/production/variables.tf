variable "region" {
   type = string
   description = "AWS Region"
   default     = "eu-west-1"
}

variable "profile" {
   type = string
   description = "AWS Profile in .credentials"
   default     = "personal"
}

# DB Variables

variable "db_instance_class" {
   description = "DB instance class"
   type        = string
   default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "DB engine version"
  type        = string
  default     = "13.1"
}

variable "db_name" {
  description = "DB schema name"
  type        = string
  default     = "app"
}

variable "db_user" {
  description = "Username for DB master user"
  type        = string
  default     = "dbuser"
}

variable "db_password" {
  description = "Password for DB master user"
  type        = string
  default     = "dbpassword"
}

# Networking variables

variable "az_1" {
   description = "Availability zone 1"
   type        = string
   default     = "eu-west-1a"
}

variable "az_2" {
   description = "Availability zone 1"
   type        = string
   default     = "eu-west-1b"
}

variable "vpc_cidr_block" {
   description = "VPC CIDR"
   type        = string
   default     = "10.0.0.0/16"
}

variable "subnet_cidr_block_1" {
   description = "Subnet CIDR"
   type        = string
   default     = "10.0.0.0/20"
}

variable "subnet_cidr_block_2" {
   description = "Subnet CIDR"
   type        = string
   default     = "10.0.16.0/20"
}

# Autoscaling

variable "ec2_instance_type" {
   description = "EC2 instance type"
   type        = string
   default     = "t2.micro"
}

variable "asg_desired_capacity" {
   description = "EC2 Desired count"
   type        = number
   default     = 2
}

variable "asg_min_size" {
   description = "EC2 min count"
   type        = number
   default     = 1
}

variable "asg_max_size" {
   description = "EC2 max count"
   type        = number
   default     = 2
}

# ECS

variable "ecs_desired_count" {
   description = "ECS Service desired contianer count"
   type        = number
   default     = 1
}