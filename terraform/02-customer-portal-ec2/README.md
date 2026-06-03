# This module does this:
Reads networking configuration from the first folder
Finds Amazon Linux image
Creates EC2 in public subnet
Attaches web security group
Installs Python
Creates a small Customer Portal web page
Prints the URL

# This EC2 instance represents the first version of a telecom CRM / Customer Portal.
----------------
# provider.tf

This file tells Terraform:
Use AWS
Use AWS provider version 5.x
Deploy into us-east-1
# Without this file, Terraform would not know which cloud provider to talk to.

# variables.tf

This file stores reusable values:
aws_region = us-east-1
project_name = telco-bss-oss
key_name = telco-key

# Why this is useful:
Instead of hardcoding values everywhere, we define them once and reuse them.
# key_name is important because EC2 needs a key pair if you want to SSH into the server.

# main.tf

This is the main file.
1. Reads Module 1 networking
data "terraform_remote_state" "networking"
# This means:
Module 2 reads the Terraform state file from Module 1.

It gets:
public_subnet_id
web_security_group_id
# So Module 2 can place EC2 inside the correct subnet and attach the correct security group.
This is more professional than copying IDs manually.

2. Finds Amazon Linux AMI
data "aws_ami" "amazon_linux"
AMI means:
Amazon Machine Image
It is the operating system image for EC2.

We are asking AWS:
Find the latest Amazon Linux 2023 image.
# This avoids hardcoding an AMI ID, because AMI IDs can change by region and over time.

3. Creates EC2 instance
resource "aws_instance" "customer_portal"
This creates a virtual server.

# Important settings:
ami = Amazon Linux 2023
instance_type = t2.micro
subnet_id = public subnet from Module 1
security_group = web security group from Module 1
associate_public_ip_address = true
key_name = telco-key

# Meaning:
The EC2 instance is placed in the public subnet and given a public IP address so you can open it from your browser.

4. Runs startup script
user_data = <<-EOF
user_data is a script that runs automatically when the EC2 instance starts for the first time.
It does this:
Updates the server
Installs Python 3
Creates a small web app
Runs the app on port 80
Port 80 is HTTP, so you can open:

http://EC2_PUBLIC_IP
in your browser.

# outputs.tf
This file prints useful values after deployment:
customer_portal_public_ip
customer_portal_url
# Example:
customer_portal_url = "http://3.91.xxx.xxx"
You use this URL to test the application.

# How to test Module 2
Go to the module folder:
cd ~/aws-telco-bss-oss-platform/terraform/02-customer-portal-ec2
Run:
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply

After terraform apply, you should see:
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
Then outputs like:
customer_portal_public_ip = "x.x.x.x"
customer_portal_url = "http://x.x.x.x"
Verify in AWS Console

# To verify in AWS Console
Go to:
AWS Console → EC2 → Instances
Check that you see:
telco-bss-oss-customer-portal-ec2
It should show:
Instance state: Running
Status checks: 2/2 checks passed
Public IPv4 address: exists
Subnet: telco-bss-oss-public-subnet
Security group: telco-bss-oss-web-sg
Verify in browser
Copy the output URL:
http://x.x.x.x
Open it in your browser.

You should see:
Telco BSS/OSS Customer Portal
Module 2: EC2 Customer Portal is running successfully.
Use Case: Customer onboarding and service activation.
If you see this, Module 2 is working.

# Verify from terminal
Run:
curl http://YOUR_PUBLIC_IP
Example:
curl http://3.91.xxx.xxx
You should get HTML text back.
If the website does not open
# Check these in order:
EC2 is running
EC2 → Instances → Running
Status checks passed
2/2 checks passed
Security group allows HTTP

Inbound rules should include:

HTTP 80 from 0.0.0.0/0
EC2 has public IP

If there is no public IP, browser cannot reach it.

Public subnet route table has internet route

Route table should include:

0.0.0.0/0 → Internet Gateway
User data completed

SSH into EC2 and check:

ps aux | grep app.py

# Most important concepts
EC2 = virtual server
AMI = operating system image
Instance type = server size
Public IP = reachable from internet
Security group = instance firewall
User data = startup automation script
Key pair = SSH login credential
Remote state = reuse outputs from another Terraform module