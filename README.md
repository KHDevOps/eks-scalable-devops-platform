![Diagram](/assets/eks_scalable_devops_platform_diagram.svg "Diagram")

# EKS Scalable DevOps Platform

A complete DevOps platform on AWS EKS with GitOps, monitoring, and CI/CD.

## Table of Contents

- [About](#about)
- [Installation](#installation)
- [Cleanup](#cleanup)
- [License](#license)
- [Author](#author)

## About

**EKS Scalable DevOps Platform** is a comprehensive, production-ready infrastructure solution designed to simplify the deployment and management of Kubernetes-based applications on AWS EKS. It follows high standards of security, scalability, and maintainability, utilizing proven DevOps practices including GitOps architecture, Infrastructure as Code, and cloud-native patterns. These approaches ensure the following benefits:

- **Security**: Enterprise-grade security practices with proper RBAC, network policies, secret management and VPC.
- **Scalability**: Auto-scaling capabilities for both infrastructure and applications, ensuring optimal resource utilization.
- **Maintainability**: Clear structure and separation facilitate better management of the codebase.
- **Observability**: Complete monitoring and alerting stack pre-integrated, utilizing Prometheus and Grafana.
- **Automation**: Complete CI/CD pipeline with Jenkins for continuous integration and ArgoCD for GitOps-based continuous deployment, enabling fully automated software delivery.

## Installation

### Prerequisities

- [**Amazon Web Services subscription**](https://aws.amazon.com/pricing/)
- [**AWS CLI**](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [**Terraform**](https://developer.hashicorp.com/terraform/install)
- [**Kubectl**](https://kubernetes.io/releases/download/)
- [**Helm**](https://helm.sh/docs/intro/install/)
- [**Ansible**](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### Fork the repository

Fork this repository on GitHub by clicking the "Fork" button

Clone your forked repository:

```bash
git clone git@github.com:<username>/eks-scalable-devops-platform.git
cd eks-scalable-devops-platform
```

### Configure AWS CLI

Authenticate with AWS:

```bash
aws configure
```

Enter your AWS credentials when prompted.

### Request an SSL Certificate in AWS Certificate Manager

Before deploying the infrastructure, you need to request an SSL certificate for your domain:

1. Go to AWS Certificate Manager in the AWS Console
2. Click "Request a certificate" and select "Request a public certificate"
3. Enter your domain name (e.g., `yourdomain.com`) and add a wildcard subdomain (e.g., `*.yourdomain.com`)
4. Choose DNS validation method (recommended)
5. Add tags if needed and click "Request"
6. Follow the DNS validation process:
   - In the certificate details, look for the CNAME records AWS provides
   - Add these CNAME records to your domain's DNS settings
   - Wait for validation to complete (can take up to 30 minutes)

Make note of the certificate ARN as you'll need it for the next step.

### Deploy Infrastructure with Terraform

```bash
cd terraform/environnements/dev
terraform init
terraform apply
```

### Deploy Your Image

```bash
terraform output ecr_repository_url
```

Edit `kubernetes/app/overlays/dev/kustomization.yaml` and update the image URL:

```yaml
images:
- name: hello-app
  newName: <your_ecr_url>
  newTag: latest
```

Build and push your image:

```bash
export AWS_REGION=$(terraform output -raw aws_region)
export ECR_URL=$(terraform output -raw ecr_repository_url)

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL

docker build -t hello-app ./app/
docker tag hello-app:latest $ECR_URL:latest
docker push $ECR_URL:latest
```

To use your own code instead of the example app, modify:

`app/` - Your application source code
`kubernetes/app/` - Kubernetes manifests for your app


### Configure ArgoCD Applications using Ansible

Once the infrastructure is ready and the image pushed to the registry, deploy ArgoCD applications:

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argo-cd argo/argo-cd -n argocd --create-namespace

kubectl apply -f kubernetes/argocd/dev
```

### Configure DNS Records

Get the load balancer DNS name:

```bash
terraform output load_balancer_dns_name
```
Then, create the following CNAME records in your domain provider:

- prometheus.<yourdomain>.com → $LB_DNS
- jenkins.<yourdomain>.com → $LB_DNS
- argocd.<yourdomain>.com → $LB_DNS
- alertmanager.<yourdomain>.com → $LB_DNS
- grafana.<yourdomain>.com → $LB_DNS

## CleanUp

```bash
cd terraform/environnements/dev
terraform destroy
```

**Note**: This will completely remove all resources.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Author

Developed by Léo Mendoza. Feel free to reach out for questions, contributions, or feedback at leo.mendoza.pro@outlook.com