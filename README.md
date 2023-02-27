# terraform-google-analytics

## Description
This module will prepare a Google Project to receive session and hit level data from either Google Analytics 4 (free) or Google Analytice 360 (premium) into Google BigQuery. Due to the manual process of linking Google Analytics to Bigquery the Terraform process must be run twice. Once to disable the Org Policy constraint to allow the service account IAM policy updates, and again to turn the inherit the constrain of the folder or Organization.

### Reference Architecture
![Reference Architecture](diagram/GATOBQ.png)

The resources/services/activations/deletions that this module will create/trigger are:
- Enable Bigquery & IAM service
- Set turn_off_org_constraint to true to allow Google Analytics service accounts to be added to IAM policy
- Create a custom IAM roles for Google Analytics service accounts and human users
- Assign Google Analytics Service Accounts and Google Group to the custom IAM roles
- Human user will follow [manual instructions](https://support.google.com/analytics/answer/3416092?hl=en#step3&zippy=%2Cin-this-article) to link BigQuery to Google Analytics
- Update turn_off_org_constraint variable to false to inherit Folder or Organization constraint setting
- Run Terraform apply to inherit Folder or Organization constraint setting

## Usage

Basic usage of this module is as follows:

```hcl
module "analytics_360" {
  source  = "github.com/jasonbisson/terraform-google-modules/analytics-360/"
  version = "~> 0.1"
  turn_off_org_constraint = "true"
  ga_group = "Google Group for Analytics Admins"
  project_id  = "<PROJECT ID>"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activate\_apis | The list of apis to activate within the project | `list(string)` | <pre>[<br>  "bigquery.googleapis.com",<br>  "iam.googleapis.com"<br>]</pre> | no |
| constraint | The list of constraints to disable | `string` | `"iam.allowedPolicyMemberDomains"` | no |
| description | Description of Custom role. | `string` | `"Google Analytics custom role to write website data to BigQuery"` | no |
| disable\_dependent\_services | Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services | `string` | `"false"` | no |
| disable\_services\_on\_destroy | Whether project services will be disabled when the resources are destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy | `string` | `"false"` | no |
| enable\_apis | Whether to actually enable the APIs. If false, this module is a no-op. | `string` | `"true"` | no |
| firebase\_service\_account | Google Analytics Firebase service account | `string` | `"firebase-measurement@system.gserviceaccount.com"` | no |
| ga360\_service\_account | Google Analytics 360 service account | `string` | `"analytics-processing-dev@system.gserviceaccount.com"` | no |
| ga\_group | The name of Google group with Analytics users that need to link BigQuery to Google Analytics | `string` | n/a | yes |
| project\_id | The project ID to deploy to | `string` | n/a | yes |
| sa\_permissions | IAM permissions assigned to Custom Role. | `list(string)` | <pre>[<br>  "bigquery.datasets.create",<br>  "bigquery.datasets.get",<br>  "bigquery.tables.create",<br>  "bigquery.tables.get",<br>  "bigquery.tables.delete",<br>  "bigquery.tables.updateData",<br>  "bigquery.jobs.create",<br>  "bigquery.jobs.list",<br>  "resourcemanager.projects.get"<br>]</pre> | no |
| sa\_role\_id | ID of the Custom Role. | `string` | `"GA_EXPORT_SA"` | no |
| sa\_title | Human-readable title of the Custom Role, defaults to role\_id. | `string` | `"Google Analytics service account that writes website data to BigQuery"` | no |
| stage | The current launch stage of the role. Defaults to GA. | `string` | `"GA"` | no |
| turn\_off\_org\_constraint | Turn off Org Policy Constraint | `bool` | `true` | no |
| user\_permissions | IAM permissions assigned to Custom Role. | `list(string)` | <pre>[<br>  "resourcemanager.projects.get",<br>  "serviceusage.services.list",<br>  "serviceusage.services.enable",<br>  "resourcemanager.projects.setIamPolicy"<br>]</pre> | no |
| user\_role\_id | ID of the Custom Role. | `string` | `"GA_EXPORT_USER"` | no |
| user\_title | Human-readable title of the Custom Role, defaults to role\_id. | `string` | `"Google Group for users running one time link of Google Analytics to BigQuery"` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3x
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.0

### Service Account

A service account or user with the following roles must be used to provision
the resources of this module:

- Role Administrator: `roles/iam.roleAdmin`
- Organization Policy Administrator: `roles/orgpolicy.policyAdmin`
- Project IAM Admin: `roles/resourcemanager.projectIamAdmin`

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Identity & Access Management: `iam.googleapis.com`
- BigQuery: `bigquery.googleapis.com`

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).

## Troubleshooting

### VPC Service Controls
It's crucial to note VPC Service Controls configuration could block the linking and ongoing export of Analytics data to Bigquery. If VPC Service Controls is enabled the Google Analytics service accounts and human user will need to be added to the access level.
