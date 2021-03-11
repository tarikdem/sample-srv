resource "aws_launch_configuration" "production_launch_configuration" {
    name_prefix                 = "production-lc"
    image_id                    = "ami-0705067b7e2695161"
    iam_instance_profile        = aws_iam_instance_profile.production_ec2_role.name
    security_groups             = [aws_security_group.production_cluster_sg.id]
    user_data                   = "#!/bin/bash\necho ECS_CLUSTER=production >> /etc/ecs/ecs.config"
    instance_type               = var.ec2_instance_type
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "production_asg" {
    name                      = "production_asg"
    vpc_zone_identifier       = [aws_subnet.production_cluster_subnet_1.id, aws_subnet.production_cluster_subnet_2.id]
    launch_configuration      = aws_launch_configuration.production_launch_configuration.name

    desired_capacity          = var.asg_desired_capacity
    min_size                  = var.asg_min_size
    max_size                  = var.asg_max_size
    health_check_grace_period = 300
    health_check_type         = "EC2"
}