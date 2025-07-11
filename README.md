# pet-adoption1
Pet Adoption Shop – Automation Project
Overview
The Pet Adoption Shop project is a Java-based web application that simulates a platform for adopting pets. This project showcases full DevOps lifecycle automation using CI/CD pipelines. It integrates source control, build automation, security scanning, infrastructure provisioning, configuration management, and deployment.

Project Objectives
•	Automate the build, test, and deployment of a Java web application
•	Ensure code quality, security scanning, and containerization
•	Deploy artifacts to Nexus and environments via Ansible
•	Use scalable infrastructure with Auto Scaling Groups (ASG)
•	Monitor deployments and notify stakeholders using Slack

Technologies Used
Version Control: Git & GitHub
Build Tool: Maven
CI/CD: Jenkins
Infrastructure: AWS (EC2, S3, ASG, IAM, Route53)
IaC: Terraform
Configuration Management: Ansible
Artifact Repository: Nexus 3
Security Scanning: OWASP Dependency Check, Trivy
Monitoring & Notification: Slack
Secrets Management: HashiCorp Vault
Code Quality: SonarQube

CI/CD Pipeline Workflow
Code Analysis: Triggered by Git push, runs SonarQube
Security Scan: OWASP and Trivy scans
Build: Maven packages the WAR file
Publish: Uploads WAR to Nexus
Dockerize: Builds and pushes Docker image
Deploy: Ansible dynamically fetches EC2 IPs and deploys to stage/prod
Notify: Sends status updates via Slack
Monitor: Website availability checked 

Security & Access
All SSH access routed via a Bastion Host
IAM roles permissions
Secrets and credentials stored securely in Vault with AWS KMS managing tokens
S3 used to distribute Ansible scripts to EC2 instances

Prerequisites
AWS CLI & IAM setup
Jenkins server with required plugins
Nexus & SonarQube setup
Terraform installed
Ansible installed on a central EC2 instance

Lessons Learned
•	The importance of dynamic inventory for scaling
•	Secure handling of credentials with Vault
•	Debugging dependency check issues in CI/CD
•	Managing state with remote S3 buckets for Terraform

Future Enhancements
•	Improve security by refining the least privilege IAM policies
•	Investigate and fix the root cause of the NVD failure despite the newly generated api key and the key being properly stored in Jenkins under credentials

Maintainer
Bolatito Adegoroye
For inquiries or contributions, please contact via GitHub or slack
