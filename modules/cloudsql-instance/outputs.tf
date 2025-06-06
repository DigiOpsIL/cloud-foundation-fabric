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
  _all_instances = merge(
    { primary = google_sql_database_instance.primary },
    google_sql_database_instance.replicas
  )
}

output "client_certificates" {
  description = "The CA Certificate used to connect to the SQL Instance via SSL."
  value       = google_sql_ssl_cert.client_certificates
  sensitive   = true
}

output "connection_name" {
  description = "Connection name of the primary instance."
  value       = google_sql_database_instance.primary.connection_name
}

output "connection_names" {
  description = "Connection names of all instances."
  value = {
    for id, instance in local._all_instances :
    id => instance.connection_name
  }
}

output "dns_name" {
  description = "The dns name of the instance."
  value       = google_sql_database_instance.primary.dns_name
}

output "dns_names" {
  description = "Dns names of all instances."
  value = {
    for id, instance in local._all_instances :
    id => instance.dns_name
  }
}

output "id" {
  description = "Fully qualified primary instance id."
  value       = google_sql_database_instance.primary.id
}

output "ids" {
  description = "Fully qualified ids of all instances."
  value = {
    for id, instance in local._all_instances :
    id => instance.id
  }
}

output "instances" {
  description = "Cloud SQL instance resources."
  value       = local._all_instances
  sensitive   = true
}

output "ip" {
  description = "IP address of the primary instance."
  value       = google_sql_database_instance.primary.private_ip_address
}

output "ips" {
  description = "IP addresses of all instances."
  value = {
    for id, instance in local._all_instances :
    id => instance.private_ip_address
  }
}

output "name" {
  description = "Name of the primary instance."
  value       = google_sql_database_instance.primary.name
}

output "names" {
  description = "Names of all instances."
  value = {
    for id, instance in local._all_instances :
    id => instance.name
  }
}

output "psc_service_attachment_link" {
  description = "The link to service attachment of PSC instance."
  value       = google_sql_database_instance.primary.psc_service_attachment_link
}

output "psc_service_attachment_links" {
  description = "Links to service attachment of PSC instances."
  value = {
    for id, instance in local._all_instances :
    id => instance.psc_service_attachment_link
  }
}

output "self_link" {
  description = "Self link of the primary instance."
  value       = google_sql_database_instance.primary.self_link
}

output "self_links" {
  description = "Self links of all instances."
  value = {
    for id, instance in local._all_instances :
    id => instance.self_link
  }
}

output "user_passwords" {
  description = "Map of containing the password of all users created through terraform."
  value = {
    for k, v in local.users : k => v.password
  }
  sensitive = true
  depends_on = [
    google_sql_user.users
  ]
}
