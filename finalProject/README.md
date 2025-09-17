# Final DevOps Project – AWS Infrastructure with Terraform & CI/CD

### Опис проєкту

Цей проєкт демонструє повний цикл **CI/CD (Continuous Integration/Continuous Delivery)** для веб-застосунку на **Django**, розгорнутого в **AWS**. Інфраструктура описана за допомогою **Terraform (Infrastructure as Code)**, що забезпечує її відтворюваність та керованість.

---

### Ключові технології

| **Категорія**       | **Технологія**       | **Призначення**                                  |
| :------------------ | :------------------- | :----------------------------------------------- |
| **Інфраструктура**  | **AWS**              | Хмарна платформа для розгортання ресурсів.       |
|                     | **Terraform**        | Управління інфраструктурою як кодом (IaC).       |
|                     | **Kubernetes (EKS)** | Оркестрація контейнерів.                         |
|                     | **RDS**              | Реляційна база даних для застосунку.             |
|                     | **ECR**              | Репозиторій для Docker-образів.                  |
| **CI/CD & GitOps**  | **Jenkins**          | Автоматизація етапів CI/CD.                      |
|                     | **Argo CD**          | Реалізація GitOps для автоматичного деплою.      |
| **Моніторинг**      | **Prometheus**       | Збір метрик з Kubernetes.                        |
|                     | **Grafana**          | Візуалізація метрик та моніторинг стану системи. |
| **Контейнеризація** | **Docker**           | Контейнеризація Django-застосунку.               |

---

### Структура репозиторію

.
├── main.tf # Головний файл для підключення модулів
├── backend.tf # Налаштування віддаленого state'у (S3 + DynamoDB)
├── outputs.tf # Виводи важливої інформації про ресурси
│
├── modules/ # Каталог з багаторазовими модулями Terraform
│ ├── s3-backend/ # Модуль для S3 та DynamoDB
│ ├── vpc/ # Модуль для мережевої інфраструктури (VPC)
│ ├── ecr/ # Модуль для ECR-репозиторію
│ ├── eks/ # Модуль для Kubernetes (EKS) кластера
│ ├── rds/ # Модуль для RDS та Aurora
│ ├── jenkins/ # Модуль для Helm-деплою Jenkins
│ └── argo_cd/ # Модуль для Helm-деплою Argo CD
│ └── charts/ # Helm-чарт для Argo CD Applications
│
├── charts/ # Helm-чарти для застосунків
│ └── django-app/ # Chart для розгортання Django
│ ├── templates/
│ ├── Chart.yaml
│ └── values.yaml
│
└── Django/ # Каталог з кодом застосунку
├── app/
├── Dockerfile # Інструкції для створення Docker-образу
├── Jenkinsfile # Jenkins Pipeline для CI/CD
└── docker-compose.yaml # Конфігурація для локальної розробки

---

### Покрокова інструкція

#### Крок 1: Підготовка середовища

Переконайтеся, що ви встановили **AWS CLI**, **Terraform**, **kubectl**, **Helm** та **Docker**. Налаштуйте ваші AWS-креденшіали, потім ініціалізуйте Terraform:

```bash
# Налаштування AWS CLI
aws configure

# Ініціалізація Terraform
terraform init

# Перевірка синтаксису Terraform
terraform validate
terraform plan

Крок 2: Розгортання інфраструктури
Виконайте команду terraform apply для створення всіх ресурсів в AWS:



terraform apply -auto-approve
Після завершення розгортання оновіть файл kubeconfig та перевірте стан вузлів кластера:



aws eks update-kubeconfig --region <your-region> --name <your-cluster-name>
kubectl get nodes

Крок 3: Доступ до сервісів
Використовуйте kubectl port-forward для доступу до веб-інтерфейсів, які працюють всередині Kubernetes:

Jenkins:


kubectl get all -n jenkins
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
Після цього Jenkins буде доступний за адресою http://localhost:8080.

Argo CD:


kubectl get all -n argocd
kubectl port-forward svc/argocd-server 8081:443 -n argocd
Argo CD буде доступний за адресою https://localhost:8081.

Grafana:


kubectl get all -n monitoring
kubectl port-forward svc/grafana 3000:80 -n monitoring
Grafana буде доступна за адресою http://localhost:3000.

Крок 4: Запуск застосунку
Jenkins-pipeline автоматично збереже Docker-образ вашого Django-застосунку, завантажить його в ECR, ініціює GitOps-процес через Argo CD, який розгорне застосунок у кластері EKS з використанням Helm-чарту.

⚠️ Важлива примітка щодо витрат
УВАГА! Щоб уникнути непередбачених витрат на хмарні сервіси, обов'язково видаляйте всі створені ресурси після завершення роботи. Виконайте таку команду:


terraform destroy -auto-approve
Ця команда видалить усі ресурси, які використовуються для зберігання стану Terraform. Тому, при повторному запуску проєкту, їх потрібно буде створити знову.
```
