resource "aws_vpc" "production_vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.production_vpc.id
}

resource "aws_subnet" "production_cluster_subnet_1" {
    vpc_id                  = aws_vpc.production_vpc.id
    cidr_block              = var.subnet_cidr_block_1
    availability_zone       = var.az_1
}

resource "aws_subnet" "production_cluster_subnet_2" {
    vpc_id                  = aws_vpc.production_vpc.id
    cidr_block              = var.subnet_cidr_block_2
    availability_zone       = var.az_2
}

resource "aws_route_table" "production_rtb_1" {
    vpc_id = aws_vpc.production_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table" "production_rtb_2" {
    vpc_id = aws_vpc.production_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "route_table_association_1" {
    subnet_id      = aws_subnet.production_cluster_subnet_1.id
    route_table_id = aws_route_table.production_rtb_1.id
}

resource "aws_route_table_association" "route_table_association_2" {
    subnet_id      = aws_subnet.production_cluster_subnet_2.id
    route_table_id = aws_route_table.production_rtb_2.id
}

resource "aws_security_group" "production_alb_sg" {
    vpc_id      = aws_vpc.production_vpc.id
    
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        description     = "Allow HTTP access from internet"
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        description     = "Allow HTTPS access from internet"
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "production_cluster_sg" {
    vpc_id      = aws_vpc.production_vpc.id

    ingress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        security_groups = [aws_security_group.production_alb_sg.id]
        description     = "Allow access from ALB SG"
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "production_rds_sg" {
    vpc_id      = aws_vpc.production_vpc.id

    ingress {
        protocol        = "tcp"
        from_port       = 5432
        to_port         = 5432
        security_groups = [aws_security_group.production_cluster_sg.id]
        description     = "Allow access from ECS cluster SG"
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "aws_alb_target_group" "production_target_group" {
  name                = "production-app-target-group"
  port                = 80
  protocol            = "HTTP"
  vpc_id              = aws_vpc.production_vpc.id
  deregistration_delay = "10"

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "6"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_alb" "production_alb" {
  name               = "production-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.production_alb_sg.id]
  subnets            = [aws_subnet.production_cluster_subnet_1.id, aws_subnet.production_cluster_subnet_2.id]
}

resource "aws_alb_listener" "production_alb_listener" {
  load_balancer_arn = aws_alb.production_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.production_target_group.arn
    type             = "forward"
  }
}

resource "aws_autoscaling_attachment" "production_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.production_asg.name
  alb_target_group_arn   = aws_alb_target_group.production_target_group.arn
  depends_on = [ aws_autoscaling_group.production_asg ]
}
