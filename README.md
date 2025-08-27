# WordPress Infrastructure on AWS

A production-ready Terraform infrastructure for hosting WordPress on AWS with high availability, security, and scalability.

## 🏗️ Architecture

This infrastructure deploys a 3-tier WordPress application with the following components:

```
Internet Gateway
    ↓
Application Load Balancer (Public Subnets)
    ↓
EC2 Web Servers (Private App Subnets)
    ↓
RDS MySQL Database (Private DB Subnets)
    ↓
EFS Storage (Shared across AZs)
```

### Key Features

- **High Availability**: Resources deployed across 2 Availability Zones
- **Security**: Multi-layered security with isolated subnets and security groups
- **Scalability**: Load balancer ready for auto-scaling groups
- **Shared Storage**: EFS for WordPress files and media
- **Database**: RDS MySQL with multi-AZ capability

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS account with necessary permissions

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd wordpress-aws-infrastructure
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the plan**
   ```bash
   terraform plan
   ```

4. **Deploy the infrastructure**
   ```bash
   terraform apply
   ```

5. **Access your WordPress site**
   - The ALB DNS name will be output after deployment
   - Navigate to the DNS name in your browser to complete WordPress setup

## 🔧 Configuration

### Environment Variables

The infrastructure uses local variables in `main.tf` for configuration:

```hcl
locals {
  environment = "dev"        # Environment name (dev, staging, prod)
  project     = "wordpress"  # Project name for resource naming
}
```

### Customization Options

You can customize the deployment by modifying variables in the respective modules:

- **VPC CIDR**: Change `vpc_cidr` in networking module call
- **Instance Types**: Modify `instance_type` in compute module
- **Database Settings**: Adjust RDS configuration in database module
- **Region**: Update the AWS provider region

## 📁 Project Structure

```
├── main.tf                          # Main configuration and module calls
├── modules/
│   ├── networking/                  # VPC, subnets, routing
│   │   ├── variables.tf
│   │   ├── vpc.tf
│   │   ├── subnets.tf
│   │   ├── internet-gateway.tf
│   │   ├── nat-gateway.tf
│   │   ├── route-tables.tf
│   │   ├── elastic-ips.tf
│   │   └── outputs.tf
│   ├── security/                    # Security groups
│   │   ├── variables.tf
│   │   ├── security-groups.tf
│   │   └── outputs.tf
│   ├── database/                    # RDS MySQL
│   │   ├── variables.tf
│   │   ├── rds-database.tf
│   │   └── outputs.tf
│   ├── storage/                     # EFS file system
│   │   ├── variables.tf
│   │   ├── elastic-file-system.tf
│   │   └── outputs.tf
│   └── compute/                     # EC2, ALB, Target Groups
│       ├── variables.tf
│       ├── ec2.tf
│       ├── alb.tf
│       ├── target-group.tf
│       └── outputs.tf
└── README.md
```

## 🔒 Security Features

### Network Security
- **Private Subnets**: Web servers and database in private subnets
- **NAT Gateways**: Secure outbound internet access for private resources
- **Security Groups**: Least privilege access controls

### Security Groups
- **ALB Security Group**: HTTP/HTTPS from internet
- **WebServer Security Group**: HTTP/HTTPS from ALB only, SSH from SSH SG
- **Database Security Group**: MySQL access from web servers only
- **EFS Security Group**: NFS access from web servers only
- **SSH Security Group**: SSH access (restrict in production)

### Database Security
- **Private Subnets**: Database isolated from internet
- **Encryption**: RDS encryption at rest (configurable)
- **Backup**: Automated backups enabled

## 🌍 Multi-Environment Support

The infrastructure supports multiple environments through variable configuration:

```hcl
# For staging environment
locals {
  environment = "staging"
  project     = "wordpress"
}

# For production environment
locals {
  environment = "prod"
  project     = "wordpress"
}
```

Resources will be named accordingly: `{environment}-{project}-{resource-type}`

## 📊 Outputs

After deployment, Terraform will output:
- ALB DNS name for accessing WordPress
- VPC ID and subnet IDs for reference
- RDS endpoint for database connections

## 🔧 Maintenance

### Updating Infrastructure
```bash
# Make changes to .tf files
terraform plan    # Review changes
terraform apply   # Apply changes
```

### Destroying Infrastructure
```bash
terraform destroy
```

**⚠️ Warning**: This will permanently delete all resources and data.

## 🚀 Production Considerations

Before using in production, consider:

1. **Database Password**: Replace hardcoded password with AWS Secrets Manager
2. **SSH Access**: Restrict SSH security group to specific IP ranges
3. **SSL/TLS**: Configure HTTPS with ACM certificates
4. **Monitoring**: Add CloudWatch alarms and logging
5. **Backup**: Configure automated EFS and RDS backups
6. **Auto Scaling**: Implement Auto Scaling Groups for web servers
7. **CDN**: Add CloudFront for better performance

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
   - Follow Terraform best practices
   - Update documentation if needed
   - Test your changes
4. **Commit your changes**
   ```bash
   git commit -m "Add: your feature description"
   ```
5. **Push to your branch**
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Create a Pull Request**

### Development Guidelines

- **Code Style**: Follow HashiCorp's Terraform style guide
- **Variables**: Use descriptive names and include validation where appropriate
- **Documentation**: Update README.md for any architectural changes
- **Testing**: Test changes in a development environment first
- **Security**: Follow AWS security best practices

### Reporting Issues

Please use GitHub Issues to report:
- Bugs or errors
- Feature requests
- Documentation improvements
- Security concerns

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: Check this README and inline code comments
- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Discussions**: Use GitHub Discussions for questions and community support

## 🏷️ Tags

`terraform` `aws` `wordpress` `infrastructure` `iac` `devops` `cloud` `mysql` `efs` `alb` `vpc`
---
###  Author: Mon Villarin
 📌 LinkedIn: [Ramon Villarin](https://www.linkedin.com/in/ramon-villarin/)  
 📌 Portfolio Site: [MonVillarin.com](https://monvillarin.com)  
 📌 Blog Post: [Traditional 3-Tier Website Deployment on AWS: A Real-World Case Study](https://blog.monvillarin.com/traditional-3-tier-website-deployment-on-aws-a-real-world-case-study)
