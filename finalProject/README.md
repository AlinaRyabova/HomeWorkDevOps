# Final DevOps Project – AWS + Terraform + EKS + CI/CD + Monitoring

## Опис проєкту

Цей проєкт реалізує повний DevOps-процес розгортання веб-застосунку **Django** в AWS з використанням **Terraform**, **EKS**, **RDS**, **ECR**, **Jenkins**, **Argo CD**, **Prometheus** та **Grafana**.  
Інфраструктура описана як код (**IaC**) і автоматизована через Terraform.

---

## 🛠 Використані технології

- **AWS** (VPC, EKS, RDS, ECR, IAM, Security Groups)
- **Terraform** (IaC)
- **Helm** (деплой Jenkins, Argo CD, Prometheus, Grafana)
- **Jenkins** (CI/CD)
- **Argo CD** (GitOps CD)
- **Prometheus + Grafana** (моніторинг)
- **Docker** (контейнеризація Django)

---

## Структура проєкту

Project/
│
├── main.tf # Головний файл для підключення модулів
├── backend.tf # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf # Загальні виводи ресурсів
│
├── modules/ # Каталог з усіма модулями
│ ├── s3-backend/ # Модуль для S3 та DynamoDB
│ │ ├── s3.tf # Створення S3-бакета
│ │ ├── dynamodb.tf # Створення DynamoDB
│ │ ├── variables.tf # Змінні для S3
│ │ └── outputs.tf # Виведення інформації про S3 та DynamoDB
│ │
│ ├── vpc/ # Модуль для VPC
│ │ ├── vpc.tf # Створення VPC, підмереж, Internet Gateway
│ │ ├── routes.tf # Налаштування маршрутизації
│ │ ├── variables.tf # Змінні для VPC
│ │ └── outputs.tf  
│ ├── ecr/ # Модуль для ECR
│ │ ├── ecr.tf # Створення ECR репозиторію
│ │ ├── variables.tf # Змінні для ECR
│ │ └── outputs.tf # Виведення URL репозиторію
│ │
│ ├── eks/ # Модуль для Kubernetes кластера
│ │ ├── eks.tf # Створення кластера
│ │ ├── aws_ebs_csi_driver.tf # Встановлення плагіну csi drive
│ │ ├── variables.tf # Змінні для EKS
│ │ └── outputs.tf # Виведення інформації про кластер
│ │
│ ├── rds/ # Модуль для RDS
│ │ ├── rds.tf # Створення RDS бази даних  
│ │ ├── aurora.tf # Створення aurora кластера бази даних  
│ │ ├── shared.tf # Спільні ресурси  
│ │ ├── variables.tf # Змінні (ресурси, креденшели, values)
│ │ └── outputs.tf  
│ │
│ ├── jenkins/ # Модуль для Helm-установки Jenkins
│ │ ├── jenkins.tf # Helm release для Jenkins
│ │ ├── variables.tf # Змінні (ресурси, креденшели, values)
│ │ ├── providers.tf # Оголошення провайдерів
│ │ ├── values.yaml # Конфігурація jenkins
│ │ └── outputs.tf # Виводи (URL, пароль адміністратора)
│ │
│ └── argo_cd/ # Новий модуль для Helm-установки Argo CD
│ ├── jenkins.tf # Helm release для Jenkins
│ ├── variables.tf # Змінні (версія чарта, namespace, repo URL тощо)
│ ├── providers.tf # Kubernetes+Helm. переносимо з модуля jenkins
│ ├── values.yaml # Кастомна конфігурація Argo CD
│ ├── outputs.tf # Виводи (hostname, initial admin password)
│ └──charts/ # Helm-чарт для створення app'ів
│ ├── Chart.yaml
│ ├── values.yaml # Список applications, repositories
│ └── templates/
│ ├── application.yaml
│ └── repository.yaml
├── charts/
│ └── django-app/
│ ├── templates/
│ │ ├── deployment.yaml
│ │ ├── service.yaml
│ │ ├── configmap.yaml
│ │ └── hpa.yaml
│ ├── Chart.yaml
│ └── values.yaml # ConfigMap зі змінними середовища
└──Django
├── app\
 ├── Dockerfile
├── Jenkinsfile
└── docker-compose.yaml

---

## Кроки розгортання

### 1. Підготовка середовища

```bash
aws configure
terraform init
terraform validate
terraform fmt
```

2. Розгортання інфраструктури
   terraform apply -auto-approve

Онови kubeconfig і перевір вузли:

aws eks update-kubeconfig --region us-east-1 --name final-eks-cluster
kubectl get nodes

3. Jenkins
   kubectl get all -n jenkins
   kubectl port-forward svc/jenkins 8080:8080 -n jenkins

4. Argo CD
   kubectl get all -n argocd
   kubectl port-forward svc/argocd-server 8081:443 -n argocd

5. Моніторинг (Grafana + Prometheus)
   kubectl get all -n monitoring
   kubectl port-forward svc/grafana 3000:80 -n monitoring

6. Django-додаток

Збірка і пуш Docker-образу:

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <ECR_URL>

docker build -t django-app ./Django
docker tag django-app:latest <ECR_URL>/django-app:latest
docker push <ECR_URL>/django-app:latest

Argo CD автоматично задеплоїть застосунок через Helm-чарт (charts/django-app).

7. Видалення ресурсів
   terraform destroy -auto-approve
