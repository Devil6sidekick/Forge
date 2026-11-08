module "vpc" {
  source = "../../modules/vpc"

  name               = "forge-dev"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}

module "k3s_node" {
  source = "../../modules/k3s-node"

  name          = "forge-dev-k3s"
  vpc_id        = module.vpc.vpc_id           # ← VPC output
  subnet_id     = module.vpc.public_subnet_id # ← VPC output
  instance_type = "t3.small"
  my_ip = var.my_ip # format "x.x.x.x/32"
  public_key    = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

output "k3s_public_ip" {
  value = module.k3s_node.public_ip
}