from rest_framework import serializers
from .models import Role, Skill


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