variable "name_prefix" {
  description = "Name prefix for security groups"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where to create security groups"
  type        = string
}

variable "web_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules for web tier"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}