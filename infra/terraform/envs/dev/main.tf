
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"
}

module "vpc" {
  source = "../../modules/vpc"

  name               = "forge-dev"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}

module "argocd_node" {
  source = "../../modules/k3s-node"

  name          = "forge-dev-argocd"
  vpc_id        = module.vpc.vpc_id           # ← VPC output
  subnet_id     = module.vpc.public_subnet_id # ← VPC output
  instance_type = "t3.small"
  my_ip = local.my_ip # format "x.x.x.x/32"
  public_key    = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

module "apps_node" {
  source = "../../modules/k3s-node"

  name          = "forge-dev-apps"
  vpc_id        = module.vpc.vpc_id           # ← VPC output
  subnet_id     = module.vpc.public_subnet_id # ← VPC output
  instance_type = "t3.small"
  my_ip = local.my_ip # format "x.x.x.x/32"
  public_key    = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

output "apps_public_ip" {
  value = module.apps_node.public_ip
}

output "argocd_public_ip" {
  value = module.argocd_node.public_ip
}

output "apps_private_ip" {
  value = module.apps_node.private_ip
}

# ArgoCD (hub) is allowed to reach the Kubernetes API of the apps cluster
resource "aws_vpc_security_group_ingress_rule" "argocd_to_apps_api" {
  security_group_id            = module.apps_node.security_group_id
  referenced_security_group_id = module.argocd_node.security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 6443
  to_port                      = 6443
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../ansible/inventory/dev.ini"   # prod.ini in envs/prod
  content  = <<-EOT
    [apps]
    forge-dev-apps ansible_host=${module.apps_node.public_ip} ansible_user=ubuntu

    [argocd]
    forge-dev-argocd ansible_host=${module.argocd_node.public_ip} ansible_user=ubuntu
    [k3s:children]
    apps
    argocd
  EOT
}
