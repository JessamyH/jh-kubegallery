# Engineering Notes

Update after each session.

## Template

### Session date and phase

- **Built:**
- **Issues and fixes:**
- **Learned:**

## Sessions

### 5 Nov 2026 · Phase 1

- **Built:** Budget alert and L1 remote state, reusing the existing state bucket with its own key.
- **Issues and fixes:**
  - The admin user couldn't see billing. Turned on IAM access to billing as root.
  - The AWS provider download was slow on the first `terraform init`, about 10 minutes. Added a shared provider cache.
- **Learned:** The state bucket stays outside the layers, and each layer has its own state key.
