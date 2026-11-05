# L3 — Bootstrap

Argo CD and the AWS Load Balancer Controller. Everything else in the cluster is deployed by Argo CD from Git.

Planned:

- **Argo CD** — installed with the Helm provider (`argo/argo-cd` chart, pinned version).
- **AWS Load Balancer Controller** — installed with the Helm provider (`eks/aws-load-balancer-controller` chart, pinned version), using the Pod Identity role from L2.

Argo CD then deploys from this repo: media Job, Gallery Web, kube-prometheus-stack.

Depends on L2 (cluster endpoint + auth). Destroy before L2.

Status: placeholder — README only.
