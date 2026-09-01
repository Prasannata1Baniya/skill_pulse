from rest_framework import serializers
from .models import Role, Skill

from django.contrib.auth.models import User

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        write_only=True,
        min_length=8
    )

    class Meta:
        model = User
        fields = ["username", "email", "password"]

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data["username"],
            email=validated_data["email"],
            password=validated_data["password"],
        )

        return user

class SkillAnalysisRequestSerializer(serializers.Serializer):
    target_role = serializers.CharField(
        max_length=100,
        required=True
    )

    skills = serializers.ListField(
        child=serializers.CharField(),
        required=True
    )


class SkillSerializer(serializers.ModelSerializer):
    class Meta:
        model = Skill
        fields = ["id", "name"]


class RoleSerializer(serializers.ModelSerializer):
    skills = SkillSerializer(many=True, read_only=True)

    class Meta:
        model = Role
        fields = ["id", "name", "skills"]