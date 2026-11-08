variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "my_ip" {
  type = string # format "x.x.x.x/32"
}

variable "public_key" {
  type = string
}