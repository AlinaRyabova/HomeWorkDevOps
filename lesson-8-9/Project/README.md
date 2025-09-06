# Terraform RDS / Aurora Module

Цей Terraform модуль дозволяє створювати **звичайну RDS базу** або **Aurora кластер** на AWS у VPC.  
Вибір між стандартним RDS і Aurora здійснюється через змінну `use_aurora`.

---

## Приклад використання модуля

```hcl
module "rds" {
  source = "./modules/rds"

  name                = "my-db"
  db_name             = "appdb"
  username            = "admin"
  password            = "supersecret"
  vpc_id              = "vpc-123456"
  vpc_cidr_block      = "10.0.0.0/16"
  subnet_private_ids  = ["subnet-aaa", "subnet-bbb"]
  subnet_public_ids   = ["subnet-ccc", "subnet-ddd"]
  publicly_accessible = false
  multi_az            = false
  use_aurora          = true       # true -> Aurora Cluster, false -> Standard RDS
  aurora_replica_count = 1         # Кількість reader реплік для Aurora
  instance_class      = "db.t3.medium"
  allocated_storage   = 20         # Для стандартного RDS
  engine_version      = "14.7"     # Для RDS
  engine_version_cluster = "15.3"  # Для Aurora
  parameters          = {
    max_connections = "100"
    log_statement  = "none"
    work_mem       = "4MB"
  }
  tags = {
    Project = "Demo"
    Env     = "Dev"
  }
}
```

# Опис змінних

| Змінна                          | Тип          | Опис                                                      | Default             |
| ------------------------------- | ------------ | --------------------------------------------------------- | ------------------- |
| `name`                          | string       | Назва інстансу або кластера                               | –                   |
| `use_aurora`                    | bool         | Використовувати Aurora (true) чи стандартний RDS (false)  | false               |
| `db_name`                       | string       | Назва бази даних                                          | –                   |
| `username`                      | string       | Користувач бази даних                                     | –                   |
| `password`                      | string       | Пароль користувача (sensitive)                            | –                   |
| `engine`                        | string       | Двигун для стандартного RDS                               | postgres            |
| `engine_version`                | string       | Версія для стандартного RDS                               | 14.7                |
| `engine_cluster`                | string       | Двигун для Aurora                                         | aurora-postgresql   |
| `engine_version_cluster`        | string       | Версія для Aurora                                         | 15.3                |
| `instance_class`                | string       | Клас інстансу (тип EC2)                                   | db.t3.medium        |
| `allocated_storage`             | number       | Для стандартного RDS (GB)                                 | 20                  |
| `aurora_replica_count`          | number       | Кількість reader реплік для Aurora                        | 1                   |
| `publicly_accessible`           | bool         | Доступність бази з Інтернету                              | false               |
| `multi_az`                      | bool         | Multi-AZ для стандартного RDS                             | false               |
| `parameters`                    | map(string)  | Додаткові параметри бази (max_connections, work_mem тощо) | {}                  |
| `backup_retention_period`       | string       | Кількість днів для збереження бекапів                     | ""                  |
| `tags`                          | map(string)  | Теги для всіх ресурсів                                    | {}                  |
| `vpc_id`                        | string       | ID VPC                                                    | –                   |
| `vpc_cidr_block`                | string       | CIDR блок VPC                                             | –                   |
| `subnet_private_ids`            | list(string) | Список приватних subnet                                   | –                   |
| `subnet_public_ids`             | list(string) | Список публічних subnet                                   | –                   |
| `parameter_group_family_aurora` | string       | Family для Aurora PG                                      | aurora-postgresql15 |
| `parameter_group_family_rds`    | string       | Family для стандартного RDS PG                            | postgres15          |

# Як змінити тип БД, engine та клас інстансу

Тип БД:

use_aurora = true → створюється Aurora Cluster.

use_aurora = false → створюється стандартний RDS інстанс.

Engine:

Для стандартного RDS: engine та engine_version.

Для Aurora: engine_cluster та engine_version_cluster.

Клас інстансу:

Встановлюється через instance_class (db.t3.medium).

Репліки Aurora:

Кількість reader реплік задається через aurora_replica_count.

# Вихідні дані

| Output         | Опис                             |
| -------------- | -------------------------------- |
| `rds_endpoint` | Endpoint для підключення до бази |

output "rds_endpoint" {
description = "RDS endpoint for connecting to the database"
value = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.standard[0].endpoint
}

## Kоманди Terraform

# Ініціалізація

terraform init

# Перевірка плану

terraform plan

# Створення ресурсів

terraform apply

# Після завершення

terraform output rds_endpoint
