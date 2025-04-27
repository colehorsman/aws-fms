# AWS Firewall Manager (FMS) Deployment

This repository contains Terraform configurations for deploying and managing AWS Firewall Manager (FMS) resources across multiple AWS accounts.

## Overview

AWS Firewall Manager is a security management service that allows you to centrally configure and manage firewall rules across your accounts in AWS Organizations. This repository provides infrastructure as code (IaC) to automate the deployment and management of FMS resources.

## Delegated Firewall Manager Accounts

This repository uses two delegated Firewall Manager accounts:

1. **Security Lab Environment** (101010101010)
   - Used for testing and validating WAF rules
   - Allows experimentation without affecting production
   - Recommended for initial rule testing

2. **Security Production Environment** (202020202020)
   - Used for production deployment of WAF rules
   - Managed by the security team
   - Applies rules to all app team accounts

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with appropriate credentials
- AWS Organizations enabled
- Appropriate AWS IAM permissions for FMS administration
- Access to delegated Firewall Manager accounts

## Repository Structure

```
.
├── README.md
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Input variables
├── outputs.tf             # Output definitions
├── providers.tf           # Provider configurations
├── delegated-accounts.tf  # Delegated FMS account definitions
├── fms-policies/          # FMS policy configurations
│   ├── waf.tf            # WAF policies
│   ├── shield.tf         # Shield policies
│   ├── security-groups.tf # Security group policies
│   ├── waf-monitoring/   # WAF monitoring configuration
│   ├── shield/           # Shield configuration
│   └── app-teams/        # App team specific policies
│       ├── risk/         # Risk team policies
│       ├── beacon/       # Beacon team policies
│       ├── life/         # Life team policies
│       └── edh/          # EDH team policies
└── examples/              # Example configurations
```

## Monitoring WAF Logs

WAF logs are automatically configured for all policies and are stored in an S3 bucket. There are several ways to monitor WAF logs:

1. **AWS Console**:
   - Navigate to the WAF & Shield console
   - Select your Web ACL
   - Go to the "Logging" tab to view real-time logs
   - Use CloudWatch Logs Insights to query logs

2. **S3 Bucket**:
   - Logs are stored in the S3 bucket: `waf-logs-<environment>`
   - Use S3 Select or Athena to query logs
   - Logs are partitioned by date: `YYYY/MM/DD/HH`

3. **CloudWatch Metrics**:
   - WAF metrics are automatically sent to CloudWatch
   - Monitor metrics like `BlockedRequests`, `AllowedRequests`, etc.
   - Set up CloudWatch alarms for suspicious activity

4. **Security Hub**:
   - WAF findings are automatically sent to Security Hub
   - Configure Security Hub rules to alert on WAF events
   - Use Security Hub insights to analyze WAF activity

### Log Sampling

All WAF logs are configured with 100% sampling rate by default, meaning all requests are logged. This can be adjusted in the policy configuration if needed.

### Log Retention

- WAF logs in S3 are retained for 90 days
- CloudWatch Logs are retained for 30 days
- Security Hub findings are retained according to your Security Hub configuration

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Review the planned changes:
   ```
   terraform plan
   ```

3. Apply the configuration:
   ```
   terraform apply
   ```

## Features

- Centralized WAF rule management
- Shield Advanced protection
- Security group policy management
- Cross-account resource protection
- Automated policy deployment
- Multi-region support (us-east-1 and us-west-2)
- Delegated Firewall Manager accounts

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 