#!/bin/bash


# Застосування міграцій
python manage.py migrate

# Запуск сервера
python manage.py runserver 0.0.0.0:8000
