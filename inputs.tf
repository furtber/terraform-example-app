#
# This variable is passed from Jenkins parameter
#
variable "ENVIRONMENT" {}

#
# These variables are defined in ENVIRONMENT.tfvars
#
variable "instance_name"         {
  description = "Name of the application EC2 instance."
}
