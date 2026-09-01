from django.urls import path
from .views import analyze_skills

urlpatterns = [
    path("api/v1/analyze/", analyze_skills, name="analyze_skills"),
]