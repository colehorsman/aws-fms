# Beacon Team FMS Configurations

## Team Information
- **Team Name**: Beacon
- **Contact**: [Team Contact Information]
- **Description**: Beacon team's Firewall Manager Service (FMS) configurations

## FMS Configurations
This directory contains FMS configurations specific to the Beacon team's resources. These configurations will be automatically applied to the team's resources through AWS Firewall Manager.

## Special Requirements
- All Beacon team resources should be protected by WAF rules
- Specific IP allowlists may be required for certain resources
- Custom rule groups may be needed for specialized protection

## Resource Types
- Application Load Balancers
- CloudFront Distributions
- API Gateway Stages

## How to Update
1. Make changes to the `main.tf` file
2. Update this README if necessary
3. Submit a pull request for review
4. Ensure all changes follow the organization's security standards 