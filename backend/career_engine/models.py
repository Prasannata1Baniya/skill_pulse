from django.db import models


class Role(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True)

    def __str__(self):
        return self.name


class Skill(models.Model):
    name = models.CharField(max_length=100, unique=True)
    roles = models.ManyToManyField(
        Role,
        related_name="skills"
    )

    def __str__(self):
        return self.name