# L1 — Foundation

Long-lived, cheap resources that survive a cluster teardown.

Planned:

- **Remote state** — S3 bucket (versioned, encrypted, native S3 lockfile) for all three layers. Bootstrapped from local state, then migrated.
- **S3 raw** — upload target for source media.
- **S3 processed** — output of the media job.
- **ECR** — repository for the `app/` image, with a lifecycle rule to expire old tags.
- **GitHub OIDC** — identity provider + role assumable only by `JessamyH/jh-kubegallery`, scoped to pushing to ECR.

Outputs consumed by L2/L3: bucket names/ARNs, ECR repository URL.

Status: placeholder — README only.
