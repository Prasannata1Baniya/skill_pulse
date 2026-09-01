import 'package:frontend/models/skills.dart';

class Role {
  final int id;
  final String name;
  final List<Skill> skills;

  Role({
    required this.id,
    required this.name,
    required this.skills,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      skills: (json['skills'] as List<dynamic>)
          .map(
            (skill) => Skill.fromJson(
          skill,
        ),
      )
          .toList(),
    );
  }
}

