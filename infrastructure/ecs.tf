resource "aws_ecs_cluster" "app" {
  name = "Vio"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "Vio-test-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::460145940115:role/ecsTaskExecutionRole"

  memory = "512"
  cpu    = "256"

  container_definitions = jsonencode([
    {
      name      = "App"
      image     = "460145940115.dkr.ecr.eu-north-1.amazonaws.com/vio-app:latest"
      cpu       = 0
      memory    = 512
      essential = true
      command   = ["bundle", "exec", "puma"],
      portMappings = [
        {
          containerPort = 4000
          hostPort      = 4000
        }
      ]
      environment = [
        {
          name  = "DATABASE_URL"
          value = "postgres://postgres:postgres@viodb.c5htiu2ou7ka.eu-north-1.rds.amazonaws.com:5432/vio_production"
        },
        {
          name  = "RAILS_ENV"
          value = "production"
        },
        {
          name  = "SECRET_KEY_BASE"
          value = "8b14f710616bec48dda30facface86a7c00ebc2dee6e19d9b49e3ae8f8138790678dfc15152f8b3175b13b76124aad40e21a38b5c4c823a0db5918e2d08cfa37"
        },
      ]
      logConfiguration = {
        logDriver     = "awslogs"
        secretOptions = null
        options = {
          awslogs-group         = "/ecs/App"
          awslogs-region        = "eu-north-1"
          awslogs-stream-prefix = "ecs"
        }
      }
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
