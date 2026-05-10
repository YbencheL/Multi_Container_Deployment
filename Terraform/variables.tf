# variables.tf
variable "location" {
  type    = string
  default = "swedencentral"
}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "admin_username" {
  type    = string
  default = "adminuser"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/azurekey.pub"
}

variable "allowed_ip" {
  type = string
}
