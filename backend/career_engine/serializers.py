from rest_framework import serializers


class SkillAnalysisRequestSerializer(serializers.Serializer):
    target_role = serializers.CharField(
        max_length=100,
        required=True
    )

    skills = serializers.ListField(
        child=serializers.CharField(),
        required=True
    )