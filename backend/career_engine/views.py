from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from .models import Role

from .serializers import (
    SkillAnalysisRequestSerializer,
    RoleSerializer,
    RegisterSerializer,
)

@api_view(["POST"])
def register(request):
    serializer = RegisterSerializer(data=request.data)

    if serializer.is_valid():
        user = serializer.save()

        return Response(
            {
                "message": "User registered successfully.",
                "user": {
                    "id": user.id,
                    "username": user.username,
                    "email": user.email,
                },
            },
            status=status.HTTP_201_CREATED,
        )

    return Response(
        serializer.errors,
        status=status.HTTP_400_BAD_REQUEST,
    )

@api_view(["GET"])
def get_roles(request):
    roles = Role.objects.prefetch_related("skills").all()

    serializer = RoleSerializer(roles, many=True)

    return Response(
        serializer.data,
        status=status.HTTP_200_OK,
    )

@api_view(["POST"])
def analyze_skills(request):
    # Validate incoming request using serializer
    serializer = SkillAnalysisRequestSerializer(data=request.data)

    if not serializer.is_valid():
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST,
        )

    # Get validated data
    target_role = serializer.validated_data["target_role"]
    user_skills = serializer.validated_data["skills"]

    role_name = target_role.strip()

    # Find the role in the database
    try:
        role = Role.objects.get(name__iexact=role_name)
    except Role.DoesNotExist:
        return Response(
            {"detail": f"Role '{role_name}' was not found."},
            status=status.HTTP_404_NOT_FOUND,
        )

    # Get required skills from the database
    required_skills = list(
        role.skills.values_list("name", flat=True)
    )

    # Normalize user's skills
    user_skills_normalized = {
        skill.strip().lower()
        for skill in user_skills
        if skill.strip()
    }

    # Find matched skills
    matched_skills = [
        skill
        for skill in required_skills
        if skill.lower() in user_skills_normalized
    ]

    # Find missing skills
    missing_skills = [
        skill
        for skill in required_skills
        if skill.lower() not in user_skills_normalized
    ]

    # Calculate match score
    match_score = (
        int((len(matched_skills) / len(required_skills)) * 100)
        if required_skills
        else 0
    )

    # Generate recommendations
    recommendations = []

    if missing_skills:
        recommendations.append(
            f"Priority focus: Master {', '.join(missing_skills[:2])}."
        )
    else:
        recommendations.append(
            "Great job! You have all the required skills for this role."
        )

    recommendations.append(
        "Build 1 end-to-end production project proving API connection resilience."
    )

    # Return JSON response
    return Response(
        {
            "match_score": match_score,
            "matched_skills": matched_skills,
            "missing_skills": missing_skills,
            "recommendations": recommendations,
        },
        status=status.HTTP_200_OK,
    )
