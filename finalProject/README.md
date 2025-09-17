# Final DevOps Project – AWS Infrastructure with Terraform & CI/CD

### Опис проєкту

Цей проєкт демонструє повний цикл **CI/CD (Continuous Integration/Continuous Delivery)** для веб-застосунку на **Django**, розгорнутого в **AWS**. Інфраструктура описана за допомогою **Terraform (Infrastructure as Code)**, що забезпечує її відтворюваність та керованість.

---

### Ключові технології

| **Категорія**        | **Технологія**        | **Призначення**                                   |
| :------------------- | :-------------------- | :------------------------------------------------ |
| **Інфраструктура**   | **AWS**               | Хмарна платформа для розгортання ресурсів.        |
|                      | **Terraform**         | Управління інфраструктурою як кодом (IaC).        |
|                      | **Kubernetes (EKS)**  | Оркестрація контейнерів.                          |
|                      | **RDS**               | Реляційна база даних для застосунку.              |
|                      | **ECR**               | Репозиторій для Docker-образів.                   |
| **CI/CD & GitOps**   | **Jenkins**           | Автоматизація етапів CI/CD.                       |
|                      | **Argo CD**           | Реалізація GitOps для автоматичного деплою.       |
| **Моніторинг**       | **Prometheus**        | Збір метрик з Kubernetes.                         |
|                      | **Grafana**           | Візуалізація метрик та моніторинг стану системи.  |
| **Контейнеризація**  | **Docker**            | Контейнеризація Django-застосунку.                |

---

### Структура репозиторію

```bash
Project/
│
├── main.tf         # Головний файл для підключення модулів
├── backend.tf        # Налаштування бекенду для стейтів (S3 + DynamoDB
├── outputs.tf        # Загальні виводи ресурсів
│
├── modules/         # Каталог з усіма модулями
│  ├── s3-backend/     # Модуль для S3 та DynamoDB
│  │  ├── s3.tf      # Створення S3-бакета
│  │  ├── dynamodb.tf   # Створення DynamoDB
│  │  ├── variables.tf   # Змінні для S3
│  │  └── outputs.tf    # Виведення інформації про S3 та DynamoDB
│  │
│  ├── vpc/         # Модуль для VPC
│  │  ├── vpc.tf      # Створення VPC, підмереж, Internet Gateway
│  │  ├── routes.tf    # Налаштування маршрутизації
│  │  ├── variables.tf   # Змінні для VPC
│  │  └── outputs.tf
│  ├── ecr/         # Модуль для ECR
│  │  ├── ecr.tf      # Створення ECR репозиторію
│  │  ├── variables.tf   # Змінні для ECR
│  │  └── outputs.tf    # Виведення URL репозиторію
│  │
│  ├── eks/           # Модуль для Kubernetes кластера
│  │  ├── eks.tf        # Створення кластера
│  │  ├── aws_ebs_csi_driver.tf # Встановлення плагіну csi drive
│  │  ├── variables.tf   # Змінні для EKS
│  │  └── outputs.tf    # Виведення інформації про кластер
│  │
│  ├── rds/         # Модуль для RDS
│  │  ├── rds.tf      # Створення RDS бази даних
│  │  ├── aurora.tf    # Створення aurora кластера бази даних
│  │  ├── shared.tf    # Спільні ресурси
│  │  ├── variables.tf   # Змінні (ресурси, креденшели, values)
│  │  └── outputs.tf
│  │
│  ├── jenkins/       # Модуль для Helm-установки Jenkins
│  │  ├── jenkins.tf    # Helm release для Jenkins
│  │  ├── variables.tf   # Змінні (ресурси, креденшели, values)
│  │  ├── providers.tf   # Оголошення провайдерів
│  │  ├── values.yaml   # Конфігурація jenkins
│  │  └── outputs.tf    # Виводи (URL, пароль адміністратора)
│  │
│  └── argo_cd/       #  Новий модуль для Helm-установки Argo CD
│    ├── jenkins.tf    # Helm release для Jenkins
│    ├── variables.tf   # Змінні (версія чарта, namespace, repo URL тощо)
│    ├── providers.tf   # Kubernetes+Helm. переносимо з модуля jenkins
│    ├── values.yaml   # Кастомна конфігурація Argo CD
│    ├── outputs.tf    # Виводи (hostname, initial admin password)
│		  └──charts/         # Helm-чарт для створення app'ів
│ 	 	  ├── Chart.yaml
│	 	  ├── values.yaml     # Список applications, repositories
│			  └── templates/
│		    ├── application.yaml
│		    └── repository.yaml
├── charts/
│  └── django-app/
│    ├── templates/
│    │  ├── deployment.yaml
│    │  ├── service.yaml
│    │  ├── configmap.yaml
│    │  └── hpa.yaml
│    ├── Chart.yaml
│    └── values.yaml   # ConfigMap зі змінними середовища
└──Django
			 ├── app\
			 ├── Dockerfile
			 ├── Jenkinsfile
			 └── docker-compose.yaml
```

---

### Покрокова інструкція

#### Крок 1: Підготовка середовища

Переконайтеся, що у вас встановлені **AWS CLI**, **Terraform**, **kubectl**, **Helm** та **Docker**. Налаштуйте ваші AWS-креденціали, потім ініціалізуйте Terraform.

````bash
# Налаштування AWS CLI
aws configure

# Ініціалізація Terraform
terraform init

# Перевірка синтаксису та форматування коду
terraform validate
terraform fmt
-----

```
#### Крок 2: Розгортання інфраструктури

Спочатку виконайте `terraform plan`, щоб переглянути план розгортання. Потім виконайте `terraform apply` для створення всіх ресурсів в AWS.

```bash
terraform plan
terraform apply
````

Після завершення розгортання оновіть файл `kubeconfig` та перевірте стан вузлів кластера:

```bash
aws eks update-kubeconfig --region <your-region> --name <your-cluster-name>
kubectl get nodes
```

---

#### Крок 3: Доступ до сервісів

Використовуйте `kubectl port-forward` для доступу до веб-інтерфейсів, що працюють усередині Kubernetes.

**Jenkins**:

```bash
kubectl get all -n jenkins
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

Jenkins буде доступний за адресою `http://localhost:8080`.

**Argo CD**:

```bash
kubectl get all -n argocd
kubectl port-forward svc/argocd-server 8081:443 -n argocd
```

Argo CD буде доступний за адресою `https://localhost:8081`.

**Grafana**:

```bash
kubectl get all -n monitoring
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

Grafana буде доступна за адресою `http://localhost:3000`.

---

#### Крок 4: Запуск застосунку

Jenkins-pipeline автоматично виконає всі необхідні кроки: збірку Docker-образу вашого Django-застосунку, його завантаження в ECR та ініціацію GitOps-процесу через Argo CD, який розгорне застосунок у кластері EKS з використанням Helm-чарту.

---

### Видалення ресурсів

Виконайте таку команду:

```bash
terraform destroy
```

Ця команда видалить усі ресурси, створені за допомогою Terraform.
