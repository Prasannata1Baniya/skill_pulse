from django.urls import path
from .views import analyze_skills, get_roles

urlpatterns = [
    path("analyze/", analyze_skills, name="analyze_skills"),
    path("roles/", get_roles, name="get_roles"),
]