/**
 * Copyright 2025 Google LLC
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

# tfdoc:file:description IAM bindings.

locals {
  _iam_principal_roles = distinct(flatten(values(var.iam_by_principals)))
  _iam_principals = {
    for r in local._iam_principal_roles : r => [
      for k, v in var.iam_by_principals :
      k if try(index(v, r), null) != null
    ]
  }
  iam = {
    for role in distinct(concat(keys(var.iam), keys(local._iam_principals))) :
    role => concat(
      try(var.iam[role], []),
      try(local._iam_principals[role], [])
    )
  }
  iam_bindings_additive = merge(
    var.iam_bindings_additive,
    [
      for principal, roles in var.iam_by_principals_additive : {
        for role in roles :
        "iam-bpa:${principal}-${role}" => {
          member    = principal
          role      = role
          condition = null
        }
      }
    ]...
  )
}

resource "google_folder_iam_binding" "authoritative" {
  for_each = local.iam
  folder   = local.folder_id
  role     = each.key
  members  = each.value
}

resource "google_folder_iam_binding" "bindings" {
  for_each = var.iam_bindings
  folder   = local.folder_id
  role     = each.value.role
  members  = each.value.members
  dynamic "condition" {
    for_each = each.value.condition == null ? [] : [""]
    content {
      expression  = each.value.condition.expression
      title       = each.value.condition.title
      description = each.value.condition.description
    }
  }
}

resource "google_folder_iam_member" "bindings" {
  for_each = local.iam_bindings_additive
  folder   = local.folder_id
  role     = each.value.role
  member   = each.value.member
  dynamic "condition" {
    for_each = each.value.condition == null ? [] : [""]
    content {
      expression  = each.value.condition.expression
      title       = each.value.condition.title
      description = each.value.condition.description
    }
  }
}
