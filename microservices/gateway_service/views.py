
from django.http import JsonResponse

def gateway_home(request):
    return JsonResponse({'message': 'Welcome to the API Gateway'})
