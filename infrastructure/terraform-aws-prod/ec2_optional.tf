# =============================================================================
# ec2_optional.tf — OPTIONAL tiny EC2 (OFF by default)
# =============================================================================
# enable_ec2_demo=true can still incur cost. Prefer free-tier eligible types.
# ALB / ECS / ACM stay documented in README — not enabled by default.
# =============================================================================

data "aws_ami" "amazon_linux" {
  count = var.enable_ec2_demo ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "ec2_demo" {
  count = var.enable_ec2_demo ? 1 : 0

  name        = "${local.name_prefix}-ec2-sg"
  description = "Learning EC2 SG — restrict SSH to your IP"

  ingress {
    description = "SSH from allowed CIDR only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr_ssh]
  }

  ingress {
    description = "HTTP for API demo"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr_ssh]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-ec2-sg"
  }
}

resource "aws_instance" "api_demo" {
  count = var.enable_ec2_demo ? 1 : 0

  ami                    = data.aws_ami.amazon_linux[0].id
  instance_type          = "t3.micro"
  iam_instance_profile   = aws_iam_instance_profile.app.name
  vpc_security_group_ids = [aws_security_group.ec2_demo[0].id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Cloud Native Platform EC2 demo — install Docker/app yourself"
              EOF

  tags = {
    Name = "${local.name_prefix}-api-demo"
  }
}

output "ec2_public_ip" {
  description = "Public IP of demo EC2 (only if enable_ec2_demo=true)"
  value       = try(aws_instance.api_demo[0].public_ip, null)
}
