resource "aws_ecs_cluster" "app" {
  name = "Vio"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "Vio-test-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::460145940115:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"

  memory = "512"
  cpu    = "256"

  container_definitions = jsonencode([
    {
      name      = "App"
      image     = "460145940115.dkr.ecr.eu-north-1.amazonaws.com/vio-app:latest"
      cpu       = 0
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 4000
          hostPort      = 4000
        }
      ]
      environment = [
        {
          name  = "DATABASE_URL"
          value = "production"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name                 = "Backend"
  launch_type          = "FARGATE"
  cluster              = aws_ecs_cluster.app.id
  task_definition      = aws_ecs_task_definition.app.arn
  platform_version     = "1.4.0"
  force_new_deployment = true
  desired_count        = 1

  network_configuration {
    subnets          = [data.aws_subnet.main.id]
    security_groups  = [aws_security_group.backend.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "App"
    container_port   = 4000
  }

  deployment_controller {
    type = "ECS"
  }
}
