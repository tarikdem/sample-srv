[
  {
    "name": "app",
    "essential": true,
    "cpu": 1,
    "memory": 512,
    "image": "${repository_url}:latest",
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 3000
      }
    ],
    "environment": [
      {
        "name": "DATABASE_HOST",
        "value": "${db_host}"
      },
      {
        "name": "DATABASE_USER",
        "value": "${db_user}"
      },
      {
        "name": "DATABASE_PASS",
        "value": "${db_password}"
      },
      {
        "name": "DATABASE_SCHEMA",
        "value": "${db_name}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/staging-app",
        "awslogs-region": "eu-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]