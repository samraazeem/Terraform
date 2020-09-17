variable "private_key_path" {
  default= "~/sam_key.pem"
}

variable "key_name" {
  default= "sam_key"
}

variable "region" {
  default = "eu-west-1"
}

variable "network_address_space" {
  default = "10.1.0.0/16"
}

variable "subnet1_address_space" {
  default = "10.1.0.0/24"
}

variable "subnet2_address_space" {
  default = "10.1.1.0/24"
}
