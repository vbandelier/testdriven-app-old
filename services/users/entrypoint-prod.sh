#!/bin/sh

echo "Waiting for PostresSQL..."

while ! nc -z users-db 5432; do
  sleep 0.1
done

echo "PostresSQL started"

python manage.py recreate_db
python manage.py seed_db
gunicorn -b 0.0.0.0:5000 manage:app
