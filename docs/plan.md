# JH KubeGallery V1 Plan

## Working rules

- Every cluster phase must rebuild from Terraform and Git, with no manual rebuilding of earlier phases.
- Keep secrets outside Git and the cluster, such as in SSM Parameter Store.
- Tear down at the end of every session that creates a cluster, and never leave EKS running overnight.
- Update `docs/notes.md` after each session with issues and fixes.
- Update the README after each phase.

## Phase 1: Foundation (no cluster) · 1–2 sessions

- Set up the AWS Budget alert first
- Set up remote state
- Create S3 raw and processed, ECR, and the GitHub OIDC role

Done when: remote state works, the OIDC role exists, and a manual docker push works.

## Phase 2: Container images (no cluster) · 2–3 sessions

- Write Dockerfiles for Media Job and Gallery Web
- Test both locally
- Push to ECR with GitHub Actions via OIDC

Done when: Actions pushes an image tagged with the commit SHA.

## Phase 3: Cluster · 2–3 sessions

- Create the VPC, 1 NAT gateway, EKS and 2 Spot nodes
- Install the Pod Identity agent, then create the roles and associations
- Tag the public subnets kubernetes.io/role/elb=1
- Upload a sample file and run a plain Job

Done when: nodes are Ready, and a Job using its own ServiceAccount writes to S3 processed through Pod Identity.

## Phase 4: GitOps · 3–4 sessions

- Install Argo CD and the Load Balancer Controller with Terraform
- Have L3 create a root Argo CD Application, so apps are restored after each rebuild
- Add the Media Job Helm chart as a suspended CronJob
- Add the GitHub Actions image tag update
- Trigger an ImagePullBackOff on purpose and troubleshoot it

Done when: both controllers are healthy, Argo CD syncs the chart from Git, and a manually triggered Job processes a sample file.

## Phase 5: Gallery Web · 2–3 sessions

- Deploy the Deployment, Service and Ingress → ALB through Argo CD
- Give it read-only access to S3 processed

Done when: the ALB serves the gallery, and Gallery Web can’t write to S3.

## Phase 6: Observability · 2–3 sessions

- Deploy kube-prometheus-stack through Argo CD, with low resource requests and short retention
- Add a Grafana dashboard
- Store the SMTP password outside the cluster, then script the Secret and configure the email receiver
- Set a low backoffLimit, such as 0 or 1, and fail a Job on purpose

Done when: the Job reaches Failed, KubeJobFailed fires, and the email arrives.

## Phase 7: Wrap-up · 1–2 sessions

- Take screenshots before the final teardown
- Run the final teardown check
- Finish the README, using the best points from docs/notes.md, and include design decisions and the Spot trade-off
- Write the summary post and update your resume
- Record the total project cost from AWS Cost Explorer

Done when: ALB, target groups, EKS, nodes, NAT, Elastic IP and EBS volumes are gone, and L1 remains.

Estimated total: 13–20 sessions.

## Scope

- **Network and cluster:** EKS with public and private subnets, 1 NAT gateway, and an optional S3 gateway endpoint
- **Nodes:** managed node group with 2 Spot nodes, allowing `t3.medium` and `t3a.medium`, with no S3 access on the node role
- **Infrastructure:** Terraform L1/L2/L3 with remote state in S3
- **Media Job:** Helm chart with a suspended CronJob, triggered manually
- **Gallery Web:** Helm chart with a Deployment, Service and Ingress, plus read-only access to S3 processed
- **Traffic:** AWS Load Balancer Controller creates the ALB in the public subnets
- **Delivery:** GitHub Actions pushes to ECR via OIDC and updates the image tag in Git, then Argo CD syncs the charts
- **Monitoring:** `kube-prometheus-stack` with the built-in `KubeJobFailed` alert → Alertmanager email, using an SMTP Secret created outside Git
- **AWS access:** separate Pod Identity roles for Media Job, Gallery Web and the Load Balancer Controller

## Teardown

Run this at the end of every session that creates a cluster:

1. Delete the Gallery Web Argo CD Application with cascade and wait until the ALB is gone.
2. Delete any other Kubernetes resources that create AWS resources, such as PVCs.
3. Destroy L3, then L2, and keep L1.
4. Check that the ALB, target groups, EKS, nodes, NAT, Elastic IP and EBS volumes are gone.

Why this order: the AWS Load Balancer Controller creates the ALB, so Terraform doesn't track it. If the cluster is destroyed first, the ALB keeps billing and can block VPC deletion.

## Cost

These are approximate, so check them with the AWS Pricing Calculator.

| Item | Cost |
|---|---|
| EKS control plane | ~US$0.10/hr |
| 2 Spot nodes | ~US$0.03–0.05/hr |
| NAT gateway | ~US$0.06/hr plus data |
| ALB | ~US$0.03/hr plus LCUs |
| Public IPv4 and node EBS volumes | ~US$0.02–0.04/hr |
| **Total while running** | **~US$0.25–0.30/hr** |
| 16 hours of use | ~US$4–6 |
| L1 left running | Under US$1/month |

Set the AWS Budget alert to a low threshold, such as US$20/month. It can lag behind actual spend and won't stop anything automatically, so always do the manual check too.
