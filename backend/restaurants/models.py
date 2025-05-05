from django.db import models

class Restaurant(models.Model):
    name = models.CharField(max_length=200)
    address = models.TextField()
    latitude = models.FloatField()
    longitude = models.FloatField()
    description = models.TextField(blank=True, null=True)
    image_url = models.ImageField(upload_to='restaurant_images/', blank=True, null=True)  # Single image field
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name