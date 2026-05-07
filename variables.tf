variable "instance_name" {
  description = "Value of the EC2 instance's Name tag."
  type        = string
  default     = "learn-hcp-terraform-upstream"
}

variable "instance_type" {
  description = "The EC2 instance's type."
  type        = string
  default     = "t4g.micro"
}

variable "workspace_name" {
  description = "Name of the source workspace to query."
  type        = string
  default     = "learn-hcp-terraform"
}

variable "organization_name" {
  description = "Name of the HCP Terraform organization with the source workspace"
  type        = string
  default     = "TEST_GB"
}

variable "instance_subnet" {
  description = "Subnet communs"
  type        = string
}

variable "instance_security_group_ids" {
  description = "Liste des groupes de sécurité communs definis dans les var de HCP Terraform workspace"
  type        = list(string)
}

variable "key_name" {
  description = "Keys name in AWS communs"
  type        = string
}
