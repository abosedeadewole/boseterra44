#! /bin/bash
# Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
cd /tmp
sudo yum update -y
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_arm64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent 
sudo systemctl start amazon-ssm-agent
sudo systemctl status amazon-ssm-agent
