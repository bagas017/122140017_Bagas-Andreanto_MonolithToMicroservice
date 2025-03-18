
#!/bin/bash

# Menjalankan Auth Service
gnome-terminal -- bash -c "cd auth_service && python manage.py runserver 8001"

# Menjalankan Product Service
gnome-terminal -- bash -c "cd product_service && python manage.py runserver 8002"

# Menjalankan Order Service
gnome-terminal -- bash -c "cd order_service && python manage.py runserver 8003"

# Menjalankan API Gateway
gnome-terminal -- bash -c "cd gateway_service && python manage.py runserver 8000"
