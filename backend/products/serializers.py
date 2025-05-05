from rest_framework import serializers
from .models import Product
from restaurants.serializers import RestaurantSerializer

class ProductSerializer(serializers.ModelSerializer):
    restaurant = RestaurantSerializer(read_only=True)
    
    class Meta:
        model = Product
        fields = ['id', 'restaurant', 'name', 'description', 'price', 'image_url', 'category', 'created_at']

class ProductCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['name', 'description', 'price', 'category', 'image_url']