/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  host_project_ids = {
    dev-spoke-0  = module.dev-spoke-project.project_id
    prod-spoke-0 = module.prod-spoke-project.project_id
  }
  host_project_numbers = {
    dev-spoke-0  = module.dev-spoke-project.number
    prod-spoke-0 = module.prod-spoke-project.number
  }
  subnet_self_links = {
    dev-spoke-0  = module.dev-spoke-vpc.subnet_ids
    prod-spoke-0 = module.prod-spoke-vpc.subnet_ids
  }
  subnet_proxy_only_self_links = {
    dev-spoke-0 = {
      for k, v in module.dev-spoke-vpc.subnets_proxy_only :
      k => v.id
    }
    prod-spoke-0 = {
      for k, v in module.prod-spoke-vpc.subnets_proxy_only :
      k => v.id
    }
  }
  subnet_psc_self_links = {
    dev-spoke-0 = {
      for k, v in module.dev-spoke-vpc.subnets_psc : k => v.id
    }
    prod-spoke-0 = {
      for k, v in module.prod-spoke-vpc.subnets_psc : k => v.id
    }
  }
  tfvars = {
    host_project_ids             = local.host_project_ids
    host_project_numbers         = local.host_project_numbers
    regions                      = var.regions
    subnet_self_links            = local.subnet_self_links
    subnet_proxy_only_self_links = local.subnet_proxy_only_self_links
    subnet_psc_self_links        = local.subnet_psc_self_links
    vpc_self_links               = local.vpc_self_links
  }
  vpc_self_links = {
    dev-spoke-0  = module.dev-spoke-vpc.id
    prod-spoke-0 = module.prod-spoke-vpc.id
  }
}

# generate tfvars file for subsequent stages

resource "local_file" "tfvars" {
  for_each        = var.outputs_location == null ? {} : { 1 = 1 }
  file_permission = "0644"
  filename        = "${try(pathexpand(var.outputs_location), "")}/tfvars/2-networking.auto.tfvars.json"
  content         = jsonencode(local.tfvars)
}

resource "google_storage_bucket_object" "tfvars" {
  bucket  = var.automation.outputs_bucket
  name    = "tfvars/2-networking.auto.tfvars.json"
  content = jsonencode(local.tfvars)
}

resource "google_storage_bucket_object" "version" {
  count  = fileexists("fast_version.txt") ? 1 : 0
  bucket = var.automation.outputs_bucket
  name   = "versions/2-networking-version.txt"
  source = "fast_version.txt"
}

# outputs

output "dev_cloud_dns_inbound_policy" {
  description = "IP Addresses for Cloud DNS inbound policy for the dev environment."
  value       = [for s in module.dev-spoke-vpc.subnets : cidrhost(s.ip_cidr_range, 2)]
}

output "host_project_ids" {
  description = "Network project ids."
  value       = local.host_project_ids
}

output "host_project_numbers" {
  description = "Network project numbers."
  value       = local.host_project_numbers
}

output "prod_cloud_dns_inbound_policy" {
  description = "IP Addresses for Cloud DNS inbound policy for the prod environment."
  value       = [for s in module.prod-spoke-vpc.subnets : cidrhost(s.ip_cidr_range, 2)]
}

output "shared_vpc_self_links" {
  description = "Shared VPC host projects."
  value       = local.vpc_self_links
}

output "tfvars" {
  description = "Terraform variables file for the following stages."
  sensitive   = true
  value       = local.tfvars
}

output "vpn_gateway_endpoints" {
  description = "External IP Addresses for the GCP VPN gateways."
  value = {
    dev-primary = var.vpn_onprem_dev_primary_config == null ? {} : {
      for v in module.landing-to-onprem-dev-primary-vpn[0].gateway.vpn_interfaces :
      v.id => v.ip_address
    }
    prod-primary = var.vpn_onprem_prod_primary_config == null ? {} : {
      for v in module.landing-to-onprem-prod-primary-vpn[0].gateway.vpn_interfaces :
      v.id => v.ip_address
    }
  }
}
