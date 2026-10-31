# L3 — Bootstrap

Argo CD only. Everything else in the cluster is deployed by Argo CD from Git.

Planned:

- **Argo CD** — installed with the Helm provider (`argo/argo-cd` chart, pinned version).

Argo CD then deploys from this repo: media Job, Gallery Web, AWS Load Balancer Controller, kube-prometheus-stack.

Depends on L2 (cluster endpoint + auth). Destroy before L2.

Status: placeholder — README only.
