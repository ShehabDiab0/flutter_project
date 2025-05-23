from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import AllProductsListView

router = DefaultRouter()
router.register(r'products', AllProductsListView, basename='product')

urlpatterns = [
    path('', include(router.urls)),
]
