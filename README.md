AWS EKS Cluster Using Terraform

This repository provisions an Amazon EKS (Elastic Kubernetes Service) cluster on AWS using Terraform.

Prerequisites
AWS CLI
Terraform
kubectl
AWS IAM user/role with the required permissions
1. Configure AWS Credentials

Configure your AWS access key and secret key locally using the terraform profile.

aws configure --profile terraform


Enter the following details when prompted:

AWS Access Key ID
AWS Secret Access Key
Default region (e.g., ap-south-1)
Default output format (e.g., json)

Verify the configuration:

aws sts get-caller-identity --profile terraform

2. Set the AWS Profile

Set the AWS profile for the current terminal session.

Linux/macOS:

export AWS_PROFILE=terraform


Windows PowerShell:

$env:AWS_PROFILE="terraform"

3. Initialize Terraform

Clone the repository and navigate to the project directory.

git clone <YOUR_REPOSITORY_URL>
cd <REPOSITORY_DIRECTORY>
terraform init

4. Validate and Review the Configuration
terraform fmt -recursive
terraform validate
terraform plan


Review the execution plan before proceeding.

5. Create the EKS Cluster
terraform apply


Type yes when prompted to approve the changes.

6. Configure kubectl

Update your local kubeconfig to connect to the EKS cluster.

aws eks update-kubeconfig \
  --region ap-south-1 \
  --name <EKS_CLUSTER_NAME> \
  --profile terraform


Verify cluster access:

kubectl get nodes
kubectl get pods -A

7. Destroy the Infrastructure

To delete the resources created by Terraform:

terraform destroy


Type yes when prompted to confirm deletion.

Notes
Replace <YOUR_REPOSITORY_URL>, <REPOSITORY_DIRECTORY>, and <EKS_CLUSTER_NAME> with your actual values.
Use the AWS region and cluster name configured in your Terraform files.
Never commit AWS access keys, secret keys, or Terraform state files to GitHub.
Ensure the configured AWS identity has the necessary permissions to create and manage EKS and its dependent resources.