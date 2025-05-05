from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import RestaurantViewSet
from products.views import ProductViewSet

# Main router for top-level API endpoints
router = DefaultRouter()
router.register(r'restaurants', RestaurantViewSet, basename='restaurant')

# Nested router for products under each restaurant
products_router = DefaultRouter()
products_router.register(r'products', ProductViewSet, basename='product')

urlpatterns = [
    path('', include(router.urls)),                          # /restaurants/
    path('restaurants/<int:restaurant_pk>/', include(products_router.urls)),  # /restaurants/1/products/
]