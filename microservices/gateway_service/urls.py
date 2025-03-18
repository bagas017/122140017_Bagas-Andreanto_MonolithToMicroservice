
from django.urls import path, include

urlpatterns = [
    path('auth/', include('auth_service.urls')),  # Redirect ke Auth Service
    path('products/', include('product_service.urls')),  # Redirect ke Product Service
    path('orders/', include('order_service.urls')),  # Redirect ke Order Service
]
