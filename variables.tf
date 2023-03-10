/**
 * Copyright 2021 Google LLC
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

variable "project_id" {
  type        = string
  description = "The project ID to deploy to"
}

variable "enable_apis" {
  type        = string
  description = "Whether to actually enable the APIs. If false, this module is a no-op."
  default     = "true"
}

variable "disable_services_on_destroy" {
  type        = string
  description = "Whether project services will be disabled when the resources are destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy"
  default     = "false"
}

variable "disable_dependent_services" {
  type        = string
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services"
  default     = "false"
}

variable "activate_apis" {
  type        = list(string)
  description = "The list of apis to activate within the project"
  default     = ["bigquery.googleapis.com", "iam.googleapis.com"]
}

variable "constraint" {
  type        = string
  description = "The list of constraints to disable"
  default     = "iam.allowedPolicyMemberDomains"
}

variable "turn_off_org_constraint" {
  type        = bool
  description = "Turn off Org Policy Constraint"
  default     = true
}

variable "ga360_service_account" {
  type        = string
  description = "Google Analytics 360 service account"
  default     = "analytics-processing-dev@system.gserviceaccount.com"
}

variable "firebase_service_account" {
  type        = string
  description = "Google Analytics Firebase service account"
  default     = "firebase-measurement@system.gserviceaccount.com"
}

variable "ga_group" {
  type        = string
  description = "The name of Google group with Analytics users that need to link BigQuery to Google Analytics"
}

variable "sa_role_id" {
  type        = string
  description = "ID of the Custom Role."
  default     = "GA_EXPORT_SA"
}

variable "user_role_id" {
  type        = string
  description = "ID of the Custom Role."
  default     = "GA_EXPORT_USER"
}

variable "sa_title" {
  type        = string
  description = "Human-readable title of the Custom Role, defaults to role_id."
  default     = "Google Analytics service account that writes website data to BigQuery"
}

variable "user_title" {
  type        = string
  description = "Human-readable title of the Custom Role, defaults to role_id."
  default     = "Google Group for users running one time link of Google Analytics to BigQuery"
}

variable "sa_permissions" {
  type        = list(string)
  description = "IAM permissions assigned to Custom Role."
  default     = ["bigquery.datasets.create", "bigquery.datasets.get", "bigquery.tables.create", "bigquery.tables.get", "bigquery.tables.delete", "bigquery.tables.updateData", "bigquery.jobs.create", "bigquery.jobs.list", "resourcemanager.projects.get"]
}

variable "user_permissions" {
  type        = list(string)
  description = "IAM permissions assigned to Custom Role."
  default     = ["resourcemanager.projects.get", "serviceusage.services.list", "serviceusage.services.enable", "resourcemanager.projects.setIamPolicy"]
}

variable "description" {
  type        = string
  description = "Description of Custom role."
  default     = "Google Analytics custom role to write website data to BigQuery"
}

variable "stage" {
  type        = string
  description = "The current launch stage of the role. Defaults to GA."
  default     = "GA"
}
