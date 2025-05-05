from django.db import models
from restaurants.models import Restaurant

class Product(models.Model):
    restaurant = models.ForeignKey(
        Restaurant, 
        related_name='products',
        on_delete=models.CASCADE
    )
    name = models.CharField(max_length=255)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image_url = models.ImageField(upload_to='product_images/', blank=True, null=True)
    category = models.CharField(max_length=100, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name} @ {self.restaurant.name}"