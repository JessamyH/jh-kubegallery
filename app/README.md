# app

Python + FFmpeg media pipeline, packaged as a container and run as a Kubernetes Job.

Planned flow:

1. Read an object key (env var / job arg) from the S3 raw bucket.
2. Transcode / generate web renditions and thumbnails with FFmpeg.
3. Write outputs to the S3 processed bucket.

AWS credentials come from EKS Pod Identity — no keys in the image or chart.

Status: placeholder — README only.
