output "web_security_group_id" {
  description = "ID of the web security group (improved output in v1.1.0)"
  value       = module.web_security_group.security_group_id
}

output "web_security_group_arn" {
  description = "ARN of the web security group"
  value       = module.web_security_group.security_group_arn
}

output "app_security_group_id" {
  description = "ID of the application security group"
  value       = module.app_security_group.security_group_id
}

output "app_security_group_arn" {
  description = "ARN of the application security group"
  value       = module.app_security_group.security_group_arn
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = module.db_security_group.security_group_id
}

output "db_security_group_arn" {
  description = "ARN of the database security group"
  value       = module.db_security_group.security_group_arn
}

output "all_security_group_ids" {
  description = "List of all security group IDs"
  value = [
    module.web_security_group.security_group_id,
    module.app_security_group.security_group_id,
    module.db_security_group.security_group_id
  ]
}