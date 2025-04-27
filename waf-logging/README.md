# WAF Logging Configuration

This directory contains the configuration for WAF logging. WAF logs are sent to an S3 bucket via Kinesis Firehose for storage and analysis.

## Components

- **Kinesis Firehose**: Delivers WAF logs to S3
- **S3 Bucket**: Stores WAF logs with lifecycle policies
- **IAM Role**: Permissions for Kinesis Firehose to write to S3

## Log Retention

- Logs are stored in S3 for 365 days
- After 30 days, logs are moved to STANDARD_IA storage class
- After 90 days, logs are moved to GLACIER storage class
- After 365 days, logs are deleted

## How to Use

1. Enable WAF logging for your WAF ACLs by referencing the Kinesis Firehose delivery stream
2. Logs will be automatically delivered to the S3 bucket
3. Use tools like Athena to query the logs

## Example

```hcl
# Enable WAF logging for a WAF ACL
resource "aws_wafv2_web_acl_logging_configuration" "example" {
  log_destination_configs = [aws_kinesis_firehose_delivery_stream.waf_logs.arn]
  resource_arn           = aws_wafv2_web_acl.example.arn
}
``` 