# AWS EKS Cluster Using Terraform

## This Repository Provisions an Amazon EKS [Elastic Kubernetes Service] Cluster on AWS Using Terraform.

## Prerequisites
- AWS CLI
- Terraform
- Kubectl

1. Configure AWS Credentials Using terraform Profile

aws configure --profile terraform

Enter the Following Details When Prompted

AWS Access Key ID
AWS Secret Access Key
Default Region
Default Output Format

3. Initialize Terraform

Clone the Repository and Navigate to the Project Directory

git clone <GitHub_Repository_Url>
cd <GitHub_Repository_Directory>
terraform init

4. Validate and Review the Configurations
terraform fmt
terraform validate
terraform plan

Review the Execution Plan Before Proceeding

5. Create EKS Cluster
terraform apply --auto-approve

6. Configure kubectl

Update your local kubeconfig to connect to the EKS cluster.

aws eks update-kubeconfig --name <EKS_Cluster_Name> --region ap-south-1 --profile terraform


Validate Cluster Access
kubectl get nodes

7. Destroy the Infrastructure
terraform destroy --auto-approve

AWS EKS Cluster Should be Provisioned Successfully.