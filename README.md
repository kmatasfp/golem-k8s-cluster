### Purpose

This repo can be used to provision Kubernetes cluster for Golem Cloud.

### Usage
1. Fork this repository
2. Clone the forked repository to your local machine
3. Navigate to the cloned repository directory
4. Provide values for terraform variables listed here: tofu/proxmox/variables.tf
5. Initialize terraform/opentofu
   ```
   terraform/tofu init
   ```
6. Plan the infrastructure changes
   ```
   terraform/tofu plan
   ```
7. Apply the infrastructure changes
   ```
   terraform/tofu apply
   ```
