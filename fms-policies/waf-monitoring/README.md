# WAF Monitoring Configuration

This directory contains the configuration for monitoring AWS WAF using CloudWatch alarms and dashboards across multiple regions.

## Features

- CloudWatch alarms for WAF blocking thresholds in primary and DR regions
- Monitoring of blocked requests by rule and IP
- CloudWatch dashboards for WAF metrics visualization
- SNS notifications for alarm events
- Global CloudFront WAF monitoring (optional)

## Alarms Configuration

The following alarms are configured for both primary and DR regions:

1. **High Rate of Blocked Requests**
   - Triggers if more than 5 requests are blocked within 1 minute
   - Monitors overall WAF blocking activity

2. **High Rate of Blocked Requests by Rule**
   - Triggers if more than 20 requests are blocked by a specific rule within 5 minutes
   - Helps identify which rules are triggering frequently

3. **High Rate of Blocked Requests by IP**
   - Triggers if more than 10 requests are blocked from a specific IP within 1 minute
   - Useful for detecting potential attack patterns

## CloudWatch Dashboards

CloudWatch dashboards are created for each region with the following widgets:

- WAF Requests (Blocked vs. Allowed)
- Blocked Requests by Rule

## CloudFront WAF Monitoring

Global CloudFront WAF monitoring is available and can be enabled/disabled using the `cloudfront_enabled` variable. When enabled, it provides:

- Global WAF request monitoring
- Global blocked requests by rule monitoring
- Separate dashboard for CloudFront WAF metrics

## Usage

1. Configure the required variables in your `terraform.tfvars` file:

```hcl
environment    = "prod"
web_acl_name   = "your-web-acl-name"
primary_region = "us-east-1"
dr_region      = "us-west-2"
cloudfront_enabled = true
sns_topic_arn  = "arn:aws:sns:region:account-id:topic-name"
tags = {
  Environment = "prod"
  Project     = "security"
}
```

2. Apply the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```

## Customizing Alarms

You can customize the alarm thresholds by modifying the following parameters in `main.tf`:

- `period`: The time period for the alarm (in seconds)
- `threshold`: The threshold value that triggers the alarm
- `evaluation_periods`: The number of periods to evaluate

## SNS Notifications

Alarms are configured to send notifications to an SNS topic. Make sure to:

1. Create an SNS topic if you haven't already
2. Subscribe to the topic with appropriate endpoints (email, SMS, etc.)
3. Provide the SNS topic ARN in the `sns_topic_arn` variable

## Best Practices

- Regularly review and adjust alarm thresholds based on your application's traffic patterns
- Set up different thresholds for different environments (dev, staging, prod)
- Consider setting up a separate SNS topic for critical security alerts
- Regularly review the CloudWatch dashboards to identify trends and patterns
- Monitor both primary and DR regions to ensure consistent security posture
- Enable CloudFront WAF monitoring if you use CloudFront distributions 