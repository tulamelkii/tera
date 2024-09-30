variable "name_security_group" {
  description = "The name of the security group"
  type        = string
}

variable "network_id" {
  description = "The ID of the network where the security group will be created"
  type        = string
}

variable "folder_id" {
  description = "The ID of the folder where the security group will be created"
  type        = string
}

variable "protocol" {
  description = "The protocol for the security group rules"
  type        = string
  default     = "tcp"
}

variable "cidr_block_all" {
  description = "The CIDR block for allowing all traffic"
  type        = list(string)
}

variable "ingress" {
}

variable "egress" {
}
