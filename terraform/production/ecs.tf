resource "aws_ecr_repository" "production_registry" {
    name  = "production"
}

resource "aws_ecs_cluster" "production_ecs_cluster" {
    name  = "production"
}

data "template_file" "task-definition-template" {
  template = "${file("${path.root}/task-definition.json.tpl")}"

  vars = {
    repository_url = "${replace("${aws_ecr_repository.production_registry.repository_url}", "https://", "")}"
    db_host        = aws_db_instance.production_db.address
    db_name        = var.db_name
    db_user        = var.db_user
    db_password    = var.db_password
  }
}

resource "aws_ecs_task_definition" "production_task_definition" {
  family                = "production-app"
  container_definitions = data.template_file.task-definition-template.rendered
}

resource "aws_ecs_service" "production_service" {
  name            = "production-app"
  cluster         = aws_ecs_cluster.production_ecs_cluster.id
  task_definition = aws_ecs_task_definition.production_task_definition.arn
  desired_count   = var.ecs_desired_count

  load_balancer {
    target_group_arn  = aws_alb_target_group.production_target_group.arn
    container_port    = 3000
    container_name    = "app"
  }
}
