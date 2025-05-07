from rest_framework import viewsets, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Product
from .serializers import ProductSerializer, ProductCreateSerializer
from rest_framework import generics

class ProductViewSet(viewsets.ModelViewSet):
    serializer_class = ProductSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        restaurant_id = self.kwargs.get('restaurant_pk')
        return Product.objects.filter(restaurant_id=restaurant_id)

    def get_serializer_class(self):
        if self.action == 'create':
            return ProductCreateSerializer
        return ProductSerializer

    def create(self, request, *args, **kwargs):
        restaurant_id = kwargs.get('restaurant_pk')
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(restaurant_id=restaurant_id)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    

class AllProductsListView(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [IsAuthenticated]
