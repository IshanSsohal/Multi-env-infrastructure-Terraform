# Security Group
resource "aws_security_group" "sg" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_cidr_blocks
  }

  ingress {
    description = "Allow SSH from source"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Security Group Rule (if needed)
resource "aws_security_group_rule" "sg_rule" {

count                   = var.create_sg_rule ? 1 : 0
  type                    = var.sg_rule_type
  from_port               = var.sg_rule_from_port
  to_port                 = var.sg_rule_to_port
  protocol                = var.sg_rule_protocol
  security_group_id       = aws_security_group.sg.id
  source_security_group_id = var.source_security_group_id
  description             = var.sg_rule_description
}

# EC2 Instances
resource "aws_instance" "instances" {
  count                     = var.instance_count
  ami                       = var.ami
  instance_type             = var.instance_type
  subnet_id                 = var.subnet_ids[count.index]
  vpc_security_group_ids    = [aws_security_group.sg.id]
  key_name                  = var.key_name
  associate_public_ip_address = var.associate_public_ip

  user_data = var.user_data

  tags = var.instance_tags[count.index]
}
