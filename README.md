# AWS EKS Cluster Using Terraform

## This Repository Provisions an Amazon EKS [Elastic Kubernetes Service] Cluster on AWS Using Terraform.

## Prerequisites
- AWS CLI
- Terraform
- Kubectl

## Configure AWS Credentials Using Terraform Profile
```bash
aws configure --profile terraform
```

**AWS Access Key ID**<br>
**AWS Secret Access Key**<br>
**Default Region**<br>
**Default Output Format**<br>
**Enter the Required Details When Prompted**<br>

## Initialize Terraform
**Clone the Repository and Navigate to the Project Directory**
```bash
git clone <GitHub_Repository_Url>
cd <GitHub_Repository_Directory>
terraform init
```

## Validate and Review Configurations
```bash
terraform fmt
terraform validate
terraform plan
```

## Create EKS Cluster
```bash
terraform apply --auto-approve
```

## Get Cluster KubeConfig File and Validate Access
```bash
aws eks update-kubeconfig --name <EKS_Cluster_Name> --region ap-south-1 --profile terraform
kubectl get nodes
```

## Destroy the Infrastructure
```bash
terraform destroy --auto-approve
```

**AWS EKS Cluster Should be Provisioned Successfully.**