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

resource "google_project_service" "project_services" {
  project                    = var.project_id
  count                      = var.enable_apis ? length(var.activate_apis) : 0
  service                    = element(var.activate_apis, count.index)
  disable_on_destroy         = var.disable_services_on_destroy
  disable_dependent_services = var.disable_dependent_services
}

resource "google_project_organization_policy" "project_policy_list_allow_all" {
  count = var.turn_off_org_policy ? 1 : 0
  project    = var.project_id
  constraint = var.constraint
  list_policy {
    allow {
      all = true
    }
  }
}

resource "time_sleep" "wait_for_org_policy" {
  create_duration = "90s"
  depends_on      = [google_project_organization_policy.project_policy_list_allow_all]
}

#The constraint with no value will reset to inherited value from folder or org
resource "google_project_organization_policy" "project_policy_list_deny_all" {
  project    = var.project_id
  constraint = var.constraint
  depends_on = [google_project_iam_member.sa360_custom_role_member, google_project_iam_member.safirebase_custom_role_member]
}


resource "google_project_iam_custom_role" "sa_custom_role" {
  project     = var.project_id
  role_id     = var.sa_role_id
  title       = var.sa_title
  description = var.description
  permissions = var.sa_permissions
}

resource "google_project_iam_custom_role" "user_custom_role_member" {
  project     = var.project_id
  role_id     = var.user_role_id
  title       = var.user_title
  description = var.description
  permissions = var.user_permissions
}

resource "google_project_iam_member" "sa360_custom_role_member" {
  project    = var.project_id
  role       = google_project_iam_custom_role.sa_custom_role.id
  member     = "serviceAccount:${var.ga360_service_account}"
  depends_on = [time_sleep.wait_for_org_policy]
}

resource "google_project_iam_member" "safirebase_custom_role_member" {
  project    = var.project_id
  role       = "roles/bigquery.user"
  member     = "serviceAccount:${var.firebase_service_account}"
  depends_on = [time_sleep.wait_for_org_policy]
}

resource "google_project_iam_member" "user_custom_role_member" {
  project = var.project_id
  role    = google_project_iam_custom_role.user_custom_role_member.id
  member  = "group:${var.ga360_group}"
}