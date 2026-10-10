variable "apprunner_services" {
  description = <<EOT
Map of apprunner_services, attributes below
Required:
    - service_name
    - source_configuration (block):
        - authentication_configuration (optional, block):
            - access_role_arn (optional)
            - connection_arn (optional)
        - auto_deployments_enabled (optional)
        - code_repository (optional, block):
            - code_configuration (optional, block):
                - code_configuration_values (optional, block):
                    - build_command (optional)
                    - port (optional)
                    - runtime (required)
                    - runtime_environment_secrets (optional)
                    - runtime_environment_variables (optional)
                    - start_command (optional)
                - configuration_source (required)
            - repository_url (required)
            - source_code_version (required, block):
                - type (required)
                - value (required)
            - source_directory (optional)
        - image_repository (optional, block):
            - image_configuration (optional, block):
                - port (optional)
                - runtime_environment_secrets (optional)
                - runtime_environment_variables (optional)
                - start_command (optional)
            - image_identifier (required)
            - image_repository_type (required)
Optional:
    - auto_scaling_configuration_arn
    - region
    - tags
    - tags_all
    - encryption_configuration (block):
        - kms_key (required)
    - health_check_configuration (block):
        - healthy_threshold (optional)
        - interval (optional)
        - path (optional)
        - protocol (optional)
        - timeout (optional)
        - unhealthy_threshold (optional)
    - instance_configuration (block):
        - cpu (optional)
        - instance_role_arn (optional)
        - memory (optional)
    - network_configuration (block):
        - egress_configuration (optional, block):
            - egress_type (optional)
            - vpc_connector_arn (optional)
        - ingress_configuration (optional, block):
            - is_publicly_accessible (optional)
        - ip_address_type (optional)
    - observability_configuration (block):
        - observability_configuration_arn (optional)
        - observability_enabled (required)
EOT

  type = map(object({
    service_name                   = string
    auto_scaling_configuration_arn = optional(string)
    region                         = optional(string)
    tags                           = optional(map(string))
    tags_all                       = optional(map(string))
    source_configuration = object({
      authentication_configuration = optional(object({
        access_role_arn = optional(string)
        connection_arn  = optional(string)
      }))
      auto_deployments_enabled = optional(bool)
      code_repository = optional(object({
        code_configuration = optional(object({
          code_configuration_values = optional(object({
            build_command                 = optional(string)
            port                          = optional(string)
            runtime                       = string
            runtime_environment_secrets   = optional(map(string))
            runtime_environment_variables = optional(map(string))
            start_command                 = optional(string)
          }))
          configuration_source = string
        }))
        repository_url = string
        source_code_version = object({
          type  = string
          value = string
        })
        source_directory = optional(string)
      }))
      image_repository = optional(object({
        image_configuration = optional(object({
          port                          = optional(string)
          runtime_environment_secrets   = optional(map(string))
          runtime_environment_variables = optional(map(string))
          start_command                 = optional(string)
        }))
        image_identifier      = string
        image_repository_type = string
      }))
    })
    encryption_configuration = optional(object({
      kms_key = string
    }))
    health_check_configuration = optional(object({
      healthy_threshold   = optional(number)
      interval            = optional(number)
      path                = optional(string)
      protocol            = optional(string)
      timeout             = optional(number)
      unhealthy_threshold = optional(number)
    }))
    instance_configuration = optional(object({
      cpu               = optional(string)
      instance_role_arn = optional(string)
      memory            = optional(string)
    }))
    network_configuration = optional(object({
      egress_configuration = optional(object({
        egress_type       = optional(string)
        vpc_connector_arn = optional(string)
      }))
      ingress_configuration = optional(object({
        is_publicly_accessible = optional(bool)
      }))
      ip_address_type = optional(string)
    }))
    observability_configuration = optional(object({
      observability_configuration_arn = optional(string)
      observability_enabled           = bool
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.health_check_configuration == null || (v.health_check_configuration.healthy_threshold == null || (v.health_check_configuration.healthy_threshold >= 1 && v.health_check_configuration.healthy_threshold <= 20))
      )
    ])
    error_message = "must be between 1 and 20"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.health_check_configuration == null || (v.health_check_configuration.unhealthy_threshold == null || (v.health_check_configuration.unhealthy_threshold >= 1 && v.health_check_configuration.unhealthy_threshold <= 20))
      )
    ])
    error_message = "must be between 1 and 20"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.instance_configuration == null || (v.instance_configuration.cpu == null || (can(regex("256|512|1024|2048|4096|(0.25|0.5|1|2|4) vCPU", v.instance_configuration.cpu))))
      )
    ])
    error_message = ""
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.instance_configuration == null || (v.instance_configuration.memory == null || (can(regex("512|1024|2048|3072|4096|6144|8192|10240|12288|(0.5|1|2|3|4|6|8|10|12) GB", v.instance_configuration.memory))))
      )
    ])
    error_message = ""
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.source_configuration.code_repository == null || (v.source_configuration.code_repository.code_configuration == null || (v.source_configuration.code_repository.code_configuration.code_configuration_values == null || (v.source_configuration.code_repository.code_configuration.code_configuration_values.build_command == null || (length(v.source_configuration.code_repository.code_configuration.code_configuration_values.build_command) >= 0 && length(v.source_configuration.code_repository.code_configuration.code_configuration_values.build_command) <= 51200))))
      )
    ])
    error_message = "must be between 0 and 51200 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.source_configuration.code_repository == null || (v.source_configuration.code_repository.code_configuration == null || (v.source_configuration.code_repository.code_configuration.code_configuration_values == null || (v.source_configuration.code_repository.code_configuration.code_configuration_values.runtime_environment_secrets == null || (alltrue([for x in v.source_configuration.code_repository.code_configuration.code_configuration_values.runtime_environment_secrets : length(x) >= 0 && length(x) <= 2048])))))
      )
    ])
    error_message = "must be between 0 and 2048 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.source_configuration.code_repository == null || (v.source_configuration.code_repository.code_configuration == null || (v.source_configuration.code_repository.code_configuration.code_configuration_values == null || (v.source_configuration.code_repository.code_configuration.code_configuration_values.runtime_environment_variables == null || (alltrue([for x in v.source_configuration.code_repository.code_configuration.code_configuration_values.runtime_environment_variables : length(x) >= 0 && length(x) <= 51200])))))
      )
    ])
    error_message = "must be between 0 and 51200 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.source_configuration.code_repository == null || (v.source_configuration.code_repository.code_configuration == null || (v.source_configuration.code_repository.code_configuration.code_configuration_values == null || (v.source_configuration.code_repository.code_configuration.code_configuration_values.start_command == null || (length(v.source_configuration.code_repository.code_configuration.code_configuration_values.start_command) >= 0 && length(v.source_configuration.code_repository.code_configuration.code_configuration_values.start_command) <= 51200))))
      )
    ])
    error_message = "must be between 0 and 51200 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.source_configuration.code_repository == null || (length(v.source_configuration.code_repository.repository_url) >= 0 && length(v.source_configuration.code_repository.repository_url) <= 51200)
      )
    ])
    error_message = "must be between 0 and 51200 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.source_configuration.code_repository == null || (v.source_configuration.code_repository.source_directory == null || (length(v.source_configuration.code_repository.source_directory) >= 0 && length(v.source_configuration.code_repository.source_directory) <= 4096))
      )
    ])
    error_message = "must be between 0 and 4096 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.source_configuration.image_repository == null || (v.source_configuration.image_repository.image_configuration == null || (v.source_configuration.image_repository.image_configuration.runtime_environment_secrets == null || (alltrue([for x in v.source_configuration.image_repository.image_configuration.runtime_environment_secrets : length(x) >= 0 && length(x) <= 2048]))))
      )
    ])
    error_message = "must be between 0 and 2048 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.source_configuration.image_repository == null || (v.source_configuration.image_repository.image_configuration == null || (v.source_configuration.image_repository.image_configuration.runtime_environment_variables == null || (alltrue([for x in v.source_configuration.image_repository.image_configuration.runtime_environment_variables : length(x) >= 0 && length(x) <= 51200]))))
      )
    ])
    error_message = "must be between 0 and 51200 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.source_configuration.image_repository == null || (v.source_configuration.image_repository.image_configuration == null || (v.source_configuration.image_repository.image_configuration.start_command == null || (length(v.source_configuration.image_repository.image_configuration.start_command) >= 0 && length(v.source_configuration.image_repository.image_configuration.start_command) <= 51200)))
      )
    ])
    error_message = "must be between 0 and 51200 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.apprunner_services : (
        v.source_configuration.image_repository == null || (can(regex("([0-9]{12}\\.dkr\\.ecr\\.[a-z\\-]+-[0-9]{1,2}\\.amazonaws\\.com\\/.*)|(^public\\.ecr\\.aws\\/.+\\/.+)", v.source_configuration.image_repository.image_identifier)))
      )
    ])
    error_message = ""
  }
  # Note: 20 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

