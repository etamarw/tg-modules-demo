module "web_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1"

  name        = "${var.name_prefix}-web"
  description = "Security group for web tier"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = var.web_ingress_cidr_blocks
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-web"
    Tier = "web"
  })
}

module "app_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1"

  name        = "${var.name_prefix}-app"
  description = "Security group for application tier"
  vpc_id      = var.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = module.web_security_group.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app"
    Tier = "application"
  })
}

module "db_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1"

  name        = "${var.name_prefix}-db"
  description = "Security group for database tier"
  vpc_id      = var.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.app_security_group.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db"
    Tier = "database"
  })
}