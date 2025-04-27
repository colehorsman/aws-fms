# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial repository structure
- WAF policy configurations
- Shield Advanced integration
- Kinesis Firehose logging setup
- CloudWatch monitoring and alerting
- Team-specific IP sets (Mendix, Beacon)
- CODEOWNERS configuration
- Comprehensive documentation

### Changed
- Organized IP sets into team-specific and centrally managed categories
- Enhanced WAF logging configuration with Kinesis Firehose

### Security
- Implemented Shield Advanced protection
- Added WAF logging for all rules by default
- Configured secure S3 bucket policies for log storage

## [0.1.0] - 2024-03-XX

### Added
- Initial project setup
- Basic WAF policy structure
- Core infrastructure components
- Documentation framework

[Unreleased]: https://github.com/your-org/aws-fms/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/your-org/aws-fms/releases/tag/v0.1.0 