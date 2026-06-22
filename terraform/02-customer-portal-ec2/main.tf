data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "telco-bss-oss-terraform-state-a7015e3f"
    key    = "01-networking-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
# find the latest Amzon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  # get the newest matching AMI
  most_recent = true
  # AMI must be owned by amazon
  owners = ["amazon"]

  filter {
    #filter AMIs by name
    name = "name"
    # Match Amazon Linux 2023 x86_64 images
    values = ["al2023-ami-*-x86_64"]
  }
}
# create EC2 instance for the telco customer portal
resource "aws_instance" "customer_portal" {
  # use latest Amazon Linux AMI found above
  ami = "ami-074bb5e3c681b0735"

  # free tier eligible EC2 instance type
  instance_type = "t2.micro"

  # place EC2 inside public subnet from networking
  subnet_id = data.terraform_remote_state.networking.outputs.public_subnet_id

  # attach security group from networking
  vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.web_security_group_id]

  # give EC2 a public IP so browser can access it
  associate_public_ip_address = true

  # use existing EC2 keypair for SSH access
  key_name = var.key_name

  # script that runs automatically when EC2 starts
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y python3
              cat <<APP > /home/ec2-user/app.py
              from http.server import BaseHTTPRequestHandler, HTTPServer

              class Handler(BaseHTTPRequestHandler):
                  def do_GET(self):
                      self.send_response(200)
                      self.send_header("Content-type", "text/html")
                      self.end_headers()
                      html = """
                      <html>
                      <head><title>Telco Customer Portal</title></head>
                      <body>
                      <h1>Telco BSS/OSS Customer Portal</h1>
                      <p>Module 2: EC2 Customer Portal is running successfully.</p>
                      <p>Use Case: Customer onboarding and service activation.</p>
                      </body>
                      </html>
                      """
                      self.wfile.write(html.encode())

              server = HTTPServer(("0.0.0.0", 80), Handler)
              server.serve_forever()
              APP

              nohup python3 /home/ec2-user/app.py &
              EOF

  tags = {
    Name = "${var.project_name}-customer-portal-ec2"
  }
}
