
cd auth_service && python manage.py makemigrations && python manage.py migrate
cd product_service && python manage.py makemigrations && python manage.py migrate
cd order_service && python manage.py makemigrations && python manage.py migrate
cd gateway_service && python manage.py makemigrations && python manage.py migrate
