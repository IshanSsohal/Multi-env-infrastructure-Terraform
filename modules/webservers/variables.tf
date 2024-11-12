variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
}

variable "http_cidr_blocks" {
  description = "CIDR blocks allowed for HTTP access"
  type        = list(string)
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
}

variable "create_sg_rule" {
  description = "Whether to create a separate security group rule"
  type        = bool
  default     = false
}

variable "sg_rule_type" {
  description = "Type of the security group rule (ingress or egress)"
  type        = string
  default     = "ingress"
}

variable "sg_rule_from_port" {
  description = "From port for the security group rule"
  type        = number
  default = null
}

variable "sg_rule_to_port" {
  description = "To port for the security group rule"
  type        = number
  default = null
}

variable "sg_rule_protocol" {
  description = "Protocol for the security group rule"
  type        = string
  default = null
}

variable "source_security_group_id" {
  description = "Source security group ID for the rule"
  type        = string
  default = null
}

variable "sg_rule_description" {
  description = "Description for the security group rule"
  type        = string
  default = null
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}

variable "ami" {
  description = "AMI ID for the instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
}

variable "user_data" {
  description = "User data script"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}

variable "instance_tags" {
  description = "List of tags for instances"
  type        = list(map(string))
}
