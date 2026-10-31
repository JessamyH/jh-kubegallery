# L2 — Cluster

The expensive layer. Created for a session, destroyed afterwards.

Planned:

- **VPC** — public + private subnets across 2 AZs; one NAT gateway (cost over HA). Public subnets are tagged for the AWS Load Balancer Controller.
- **EKS** — managed control plane, access entries for the admin role.
- **Spot managed node group** — several instance types for Spot capacity, scale to zero when idle.
- **Pod Identity** — EKS Pod Identity agent add-on + roles and associations for:
  - `media-job` — read S3 raw, write S3 processed
  - Gallery Web — read S3 processed
  - AWS Load Balancer Controller — manage ALBs and target groups

Reads L1 outputs via `terraform_remote_state` (or data sources).

Status: placeholder — README only.
