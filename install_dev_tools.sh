#!/bin/bash
echo "=== Перевірка та встановлення Docker ==="
if ! command -v docker &> /dev/null; then
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl gnupg lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  echo "Docker встановлено" 
else
  echo "Docker вже встановлений" 
fi

echo "=== Перевірка та встановлення Docker Compose ==="
if ! command -v docker-compose &> /dev/null; then
  sudo apt-get install -y docker-compose
  echo "Docker Compose встановлено" 
else
  echo "Docker Compose вже встановлений" 
fi

echo "=== Перевірка та встановлення Python ==="
if ! command -v python3 &> /dev/null; then
  sudo apt-get install -y python3 python3-pip
  echo "Python встановлено" 
else
  echo "Python вже встановлений" 
fi

echo "=== Перевірка та встановлення Django ==="
if ! python3 -m django --version &> /dev/null; then
  pip3 install django
  echo "Django встановлено" 
else
  echo "Django вже встановлений" 
fi

echo "=== Усі інструменти готові!===" 
