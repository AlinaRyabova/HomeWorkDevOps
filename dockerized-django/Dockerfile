# Базовий образ Python
FROM python:3.11-slim

# Встановлення залежностей для psycopg2
RUN apt-get update && apt-get install -y \
    libpq-dev gcc && rm -rf /var/lib/apt/lists/*

# Робоча директорія
WORKDIR /app

# Копіюємо requirements і встановлюємо залежності
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо весь проект
COPY ./app /app

# Додаємо скрипт entrypoint
RUN chmod +x /app/entrypoint.sh

# Запуск
ENTRYPOINT ["/app/entrypoint.sh"]
