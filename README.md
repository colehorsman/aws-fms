# AWS Firewall Manager (FMS) Infrastructure

This repository contains the infrastructure as code for managing AWS Firewall Manager (FMS) policies across your organization using Terraform.

## TLDR
- **Crowdsourced**: Community-driven repository for AWS Firewall Manager best practices and implementations
- **Centralized Security**: Manages WAF, Shield Advanced, and DNS Firewall policies across multiple AWS accounts
- **Multi-Region**: Supports primary (us-east-1) and DR (us-west-2) regions with consistent security policies
- **Team-Based**: Organizes IP sets and policies by team (Risk, Beacon, Life, EDH) with custom rules
- **Monitoring**: Comprehensive CloudWatch dashboards and alerts for security events
- **Logging**: Automated WAF logging to S3 via Kinesis Firehose with encryption and retention policies
- **Security**: Implements Shield Advanced, DDoS protection, and IP reputation lists
- **CI/CD**: Automated deployment pipeline with GitHub Actions and Slack notifications
- **Versioning**: Policy versioning system with S3 storage and environment-specific configurations

## Features

- Centralized WAF rule management
- Shield Advanced integration for DDoS protection
- Enhanced logging with Kinesis Firehose
- Policy versioning and staging system
- Automated deployment pipeline
- Comprehensive monitoring and alerting
- Multi-environment support (dev/staging/prod)

## Architecture

```mermaid
graph TD
    A[FMS Admin Account] -->|Manages| B[WAF Policies]
    B -->|Applies to| C[Member Accounts]
    B -->|Logs to| D[Kinesis Firehose]
    D -->|Stores| E[S3 Bucket]
    B -->|Monitors| F[CloudWatch]
    F -->|Alerts| G[SNS Topic]
    H[Shield Advanced] -->|Protects| B
    I[DNS Firewall] -->|Protects| C
    J[Policy Versioning] -->|Manages| B
    K[Team IP Sets] -->|Configures| B
    L[Security Lab] -->|Tests| B
    M[Security Prod] -->|Deploys| B
    N[Primary Region] -->|Hosts| B
    O[DR Region] -->|Replicates| B
```

## Cost Estimation

Below is an estimated monthly cost breakdown for running this infrastructure in a production environment. Costs are approximate and may vary based on usage, region, and specific requirements.

### Monthly Cost Breakdown

| Service | Description | Monthly Cost (USD) |
|---------|-------------|-------------------|
| **FMS (Firewall Manager)** | Base cost for FMS administration | $100.00 |
| **WAF** | Web Application Firewall rules and requests | $300.00 |
| **Shield Advanced** | DDoS protection per protected resource | $3,000.00 |
| **DNS Firewall** | DNS query filtering and logging | $150.00 |
| **Kinesis Firehose** | Log delivery and processing | $200.00 |
| **S3 Storage** | Log storage and policy versioning | $50.00 |
| **CloudWatch** | Metrics, logs, and alarms | $100.00 |
| **SNS Topics** | Alert notifications | $10.00 |
| **Route53** | DNS resolution and health checks | $50.00 |
| **IAM** | Identity and access management | $0.00 |
| **Total Monthly** | | **$3,960.00** |

### Annual Cost Breakdown

| Period | Cost (USD) |
|--------|------------|
| Monthly Average | $3,960.00 |
| Annual Total | $47,520.00 |

### Cost Optimization Tips

1. **Development Environment**
   - Use Shield Standard instead of Advanced ($0/month)
   - Reduce WAF rule complexity
   - Estimated monthly cost: $500-1,000

2. **Staging Environment**
   - Use Shield Advanced with fewer protected resources
   - Moderate WAF rule complexity
   - Estimated monthly cost: $1,500-2,000

3. **Production Environment**
   - Full Shield Advanced protection
   - Complete WAF rule set
   - Estimated monthly cost: $3,500-4,500

### Cost Factors

- **Region**: Costs may vary by AWS region
- **Traffic Volume**: WAF and Shield costs scale with traffic
- **Rule Complexity**: More complex WAF rules increase processing costs
- **Log Retention**: Longer retention periods increase S3 storage costs
- **Alert Frequency**: More frequent alerts increase SNS costs

### Cost Control Measures

1. **Resource Tagging**
   - Tag all resources for cost allocation
   - Use AWS Cost Explorer for detailed analysis

2. **Log Management**
   - Implement S3 lifecycle policies
   - Use log compression
   - Set appropriate retention periods

3. **Monitoring**
   - Set up cost anomaly detection
   - Create budget alerts
   - Regular cost optimization reviews

## Prerequisites

- AWS Organizations enabled
- AWS Config enabled in member accounts
- FMS administrator account designated
- Terraform >= 1.0
- AWS CLI configured

## Directory Structure

```
.
├── logging/              # Logging configuration
├── monitoring/           # CloudWatch monitoring
├── policies/            # FMS policies
├── security/            # Shield and security configs
├── plan-demo/           # Simplified configuration for planning
├── .github/             # GitHub Actions
└── variables.tf         # Input variables
```

## Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/your-org/aws-fms
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Create a terraform.tfvars file:
   ```hcl
   name_prefix = "your-prefix"
   environment = "dev"
   ```

4. Plan and apply:
   ```bash
   terraform plan
   terraform apply
   ```

## Planning and Testing

The `plan-demo` directory contains a simplified version of the FMS configuration for planning and testing purposes. This directory includes:

- Basic FMS admin account setup
- Sample WAF policies for each team
- DNS Firewall configuration
- Security Group policies
- Example resources for testing

### Step-by-Step Demo Environment Setup

#### Prerequisites
1. Install required tools:
   ```bash
   # Install AWS CLI
   brew install awscli  # For macOS
   # OR
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  # For Linux
   unzip awscliv2.zip
   sudo ./aws/install

   # Install Terraform
   brew install terraform  # For macOS
   # OR
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
   sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
   sudo apt-get update && sudo apt-get install terraform  # For Linux
   ```

2. Configure AWS credentials:
   ```bash
   aws configure
   # Enter your:
   # - AWS Access Key ID
   # - AWS Secret Access Key
   # - Default region (e.g., us-east-1)
   # - Default output format (json)
   ```

#### Deployment Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/your-org/aws-fms.git
   cd aws-fms
   ```

2. Create a variables file:
   ```bash
   cd plan-demo
   cat > terraform.tfvars << EOF
   aws_region = "us-east-1"
   environment = "dev"
   fms_admin_account_id = "YOUR_AWS_ACCOUNT_ID"  # Replace with your AWS account ID
   vpc_id = "vpc-xxxxxxxx"  # Replace with your VPC ID
   EOF
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review the plan:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   # Type 'yes' when prompted
   ```

6. Verify the deployment:
   ```bash
   # List FMS policies
   aws fms list-policies

   # List WAF rule groups
   aws wafv2 list-rule-groups --scope REGIONAL

   # Check DNS Firewall rule groups
   aws route53resolver list-firewall-rule-groups
   ```

#### Cleanup

To remove all created resources:
```bash
terraform destroy
# Type 'yes' when prompted
```

#### Troubleshooting

Common issues and solutions:

1. **AWS Credentials Error**
   ```bash
   Error: error getting AWS credentials
   ```
   Solution: Verify AWS credentials are properly configured:
   ```bash
   aws sts get-caller-identity
   ```

2. **Permission Errors**
   ```bash
   Error: AccessDeniedException: User is not authorized to perform fms:PutPolicy
   ```
   Solution: Ensure your AWS user has the necessary FMS permissions:
   - AWSFirewallManagerServiceRole
   - AWSFirewallManagerAdminAccess

3. **VPC Not Found**
   ```bash
   Error: InvalidVpcID.NotFound: The vpc ID 'vpc-xxx' does not exist
   ```
   Solution: Update terraform.tfvars with a valid VPC ID from your account:
   ```bash
   aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,Tags[?Key==`Name`].Value|[0]]' --output table
   ```

4. **Region Mismatch**
   ```bash
   Error: InvalidParameterException: Invalid region
   ```
   Solution: Ensure the region in terraform.tfvars matches your AWS CLI configuration:
   ```bash
   aws configure get region
   ```

#### Next Steps

After successful deployment:
1. Review the created FMS policies in the AWS Console
2. Test the WAF rules with sample requests
3. Monitor CloudWatch metrics for policy effectiveness
4. Experiment with policy modifications in the plan-demo directory

This simplified configuration helps in:
- Testing policy changes before applying to production
- Understanding the basic FMS setup
- Quick prototyping of new policies
- Training and documentation purposes

## Policy Management

### Environments

- **Dev**: All rules in COUNT mode
- **Staging**: Mixed COUNT/BLOCK mode
- **Prod**: All rules in BLOCK mode

### Version Control

Policies are versioned and stored in S3. Each version includes:
- Policy configuration
- Enabled rules
- Override actions
- Timestamp

## Monitoring

### CloudWatch Metrics

- WAF blocked requests
- DDoS attacks detected
- Request rates
- Rule triggers

### Alerts

Alerts are sent to SNS topics for:
- High rate of blocked requests
- DDoS attacks
- Policy changes
- Deployment status

## Logging

Logs are collected via Kinesis Firehose and stored in S3 with:
- Partitioning by date
- Compression
- Lifecycle policies
- Encryption

## Security

- Shield Advanced integration
- DDoS protection
- IP reputation lists
- Rate-based rules
- Custom rule groups

## CI/CD Pipeline

The GitHub Actions pipeline includes:
1. Terraform validation
2. Plan generation
3. Plan review
4. Automated deployment
5. Slack notifications

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Create a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository.