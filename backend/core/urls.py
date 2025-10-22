
from .views import ping # Imported ping view from current package views module
from django.urls import path # Imported path function from django.urls

urlpatterns = [ path("ping/", ping, name="api-ping") ] # Simple ping endpoint for health checks
