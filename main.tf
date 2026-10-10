resource "aws_apprunner_service" "apprunner_services" {
  for_each = var.apprunner_services

  service_name                   = each.value.service_name
  auto_scaling_configuration_arn = each.value.auto_scaling_configuration_arn
  region                         = each.value.region
  tags                           = each.value.tags
  tags_all                       = each.value.tags_all

  source_configuration {
    dynamic "authentication_configuration" {
      for_each = each.value.source_configuration.authentication_configuration != null ? [each.value.source_configuration.authentication_configuration] : []
      content {
        access_role_arn = authentication_configuration.value.access_role_arn
        connection_arn  = authentication_configuration.value.connection_arn
      }
    }
    auto_deployments_enabled = each.value.source_configuration.auto_deployments_enabled
    dynamic "code_repository" {
      for_each = each.value.source_configuration.code_repository != null ? [each.value.source_configuration.code_repository] : []
      content {
        dynamic "code_configuration" {
          for_each = code_repository.value.code_configuration != null ? [code_repository.value.code_configuration] : []
          content {
            dynamic "code_configuration_values" {
              for_each = code_configuration.value.code_configuration_values != null ? [code_configuration.value.code_configuration_values] : []
              content {
                build_command                 = code_configuration_values.value.build_command
                port                          = code_configuration_values.value.port
                runtime                       = code_configuration_values.value.runtime
                runtime_environment_secrets   = code_configuration_values.value.runtime_environment_secrets
                runtime_environment_variables = code_configuration_values.value.runtime_environment_variables
                start_command                 = code_configuration_values.value.start_command
              }
            }
            configuration_source = code_configuration.value.configuration_source
          }
        }
        repository_url = code_repository.value.repository_url
        source_code_version {
          type  = code_repository.value.source_code_version.type
          value = code_repository.value.source_code_version.value
        }
        source_directory = code_repository.value.source_directory
      }
    }
    dynamic "image_repository" {
      for_each = each.value.source_configuration.image_repository != null ? [each.value.source_configuration.image_repository] : []
      content {
        dynamic "image_configuration" {
          for_each = image_repository.value.image_configuration != null ? [image_repository.value.image_configuration] : []
          content {
            port                          = image_configuration.value.port
            runtime_environment_secrets   = image_configuration.value.runtime_environment_secrets
            runtime_environment_variables = image_configuration.value.runtime_environment_variables
            start_command                 = image_configuration.value.start_command
          }
        }
        image_identifier      = image_repository.value.image_identifier
        image_repository_type = image_repository.value.image_repository_type
      }
    }
  }

  dynamic "encryption_configuration" {
    for_each = each.value.encryption_configuration != null ? [each.value.encryption_configuration] : []
    content {
      kms_key = encryption_configuration.value.kms_key
    }
  }

  dynamic "health_check_configuration" {
    for_each = each.value.health_check_configuration != null ? [each.value.health_check_configuration] : []
    content {
      healthy_threshold   = health_check_configuration.value.healthy_threshold
      interval            = health_check_configuration.value.interval
      path                = health_check_configuration.value.path
      protocol            = health_check_configuration.value.protocol
      timeout             = health_check_configuration.value.timeout
      unhealthy_threshold = health_check_configuration.value.unhealthy_threshold
    }
  }

  dynamic "instance_configuration" {
    for_each = each.value.instance_configuration != null ? [each.value.instance_configuration] : []
    content {
      cpu               = instance_configuration.value.cpu
      instance_role_arn = instance_configuration.value.instance_role_arn
      memory            = instance_configuration.value.memory
    }
  }

  dynamic "network_configuration" {
    for_each = each.value.network_configuration != null ? [each.value.network_configuration] : []
    content {
      dynamic "egress_configuration" {
        for_each = network_configuration.value.egress_configuration != null ? [network_configuration.value.egress_configuration] : []
        content {
          egress_type       = egress_configuration.value.egress_type
          vpc_connector_arn = egress_configuration.value.vpc_connector_arn
        }
      }
      dynamic "ingress_configuration" {
        for_each = network_configuration.value.ingress_configuration != null ? [network_configuration.value.ingress_configuration] : []
        content {
          is_publicly_accessible = ingress_configuration.value.is_publicly_accessible
        }
      }
      ip_address_type = network_configuration.value.ip_address_type
    }
  }

  dynamic "observability_configuration" {
    for_each = each.value.observability_configuration != null ? [each.value.observability_configuration] : []
    content {
      observability_configuration_arn = observability_configuration.value.observability_configuration_arn
      observability_enabled           = observability_configuration.value.observability_enabled
    }
  }
}

