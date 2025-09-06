# Terraform Project for AWS EKS, RDS/Aurora, Jenkins, and ArgoCD

## 1. Створення всіх ресурсів

Виконуємо наступні команди для ініціалізації Terraform, перегляду плану та створення ресурсів:

```bash
terraform init
terraform plan
terraform apply
```

Після успішного виконання цих команд всі необхідні ресурси будуть створені.

2. Після створення ресурсів
   а) Оновлення kubeconfig для правильного EKS кластера та регіону

aws eks update-kubeconfig --name eks-cluster-< user name > --region us-east-1

б) Перегляд сервісів Jenkins та ArgoCD

kubectl get svc -n argocd
kubectl get svc -n jenkins

в) Креденшіали до ресурсів

Jenkins:
username: admin
password: admin123

ArgoCD:
username: admin
password: (отримується з секрету)

Щоб отримати пароль для ArgoCD:

kubectl -n argocd get secret argocd-initial-admin-secret \
 -o jsonpath="{.data.password}" | base64 -d
echo

Перевіряти статус ресурсів:

kubectl get all -n jenkins
kubectl get all -n argocd

Для видалення всіх ресурсів Terraform:

terraform destroy
