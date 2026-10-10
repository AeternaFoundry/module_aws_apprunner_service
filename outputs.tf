output "apprunner_services_id" {
  description = "Map of id values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => v.id if v.id != null && length(v.id) > 0 }
}
output "apprunner_services_arn" {
  description = "Map of arn values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => v.arn if v.arn != null && length(v.arn) > 0 }
}
output "apprunner_services_auto_scaling_configuration_arn" {
  description = "Map of auto_scaling_configuration_arn values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => v.auto_scaling_configuration_arn if v.auto_scaling_configuration_arn != null && length(v.auto_scaling_configuration_arn) > 0 }
}
output "apprunner_services_encryption_configuration" {
  description = "Map of encryption_configuration values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => one(v.encryption_configuration) if v.encryption_configuration != null && length(v.encryption_configuration) > 0 }
}
output "apprunner_services_health_check_configuration" {
  description = "Map of health_check_configuration values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => one(v.health_check_configuration) if v.health_check_configuration != null && length(v.health_check_configuration) > 0 }
}
output "apprunner_services_instance_configuration" {
  description = "Map of instance_configuration values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => one(v.instance_configuration) if v.instance_configuration != null && length(v.instance_configuration) > 0 }
}
output "apprunner_services_network_configuration" {
  description = "Map of network_configuration values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => one(v.network_configuration) if v.network_configuration != null && length(v.network_configuration) > 0 }
}
output "apprunner_services_observability_configuration" {
  description = "Map of observability_configuration values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => one(v.observability_configuration) if v.observability_configuration != null && length(v.observability_configuration) > 0 }
}
output "apprunner_services_region" {
  description = "Map of region values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => v.region if v.region != null && length(v.region) > 0 }
}
output "apprunner_services_service_id" {
  description = "Map of service_id values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => v.service_id if v.service_id != null && length(v.service_id) > 0 }
}
output "apprunner_services_service_name" {
  description = "Map of service_name values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => v.service_name if v.service_name != null && length(v.service_name) > 0 }
}
output "apprunner_services_service_url" {
  description = "Map of service_url values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => v.service_url if v.service_url != null && length(v.service_url) > 0 }
}
output "apprunner_services_source_configuration" {
  description = "Map of source_configuration values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => one(v.source_configuration) if v.source_configuration != null && length(v.source_configuration) > 0 }
}
output "apprunner_services_status" {
  description = "Map of status values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => v.status if v.status != null && length(v.status) > 0 }
}
output "apprunner_services_tags" {
  description = "Map of tags values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => v.tags if v.tags != null && length(v.tags) > 0 }
}
output "apprunner_services_tags_all" {
  description = "Map of tags_all values across all apprunner_services, keyed the same as var.apprunner_services"
  value       = { for k, v in aws_apprunner_service.apprunner_services : k => v.tags_all if v.tags_all != null && length(v.tags_all) > 0 }
}

