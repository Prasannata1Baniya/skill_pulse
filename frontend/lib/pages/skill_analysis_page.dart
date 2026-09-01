import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result_page.dart';

class SkillAnalysisPage extends StatefulWidget {
  const SkillAnalysisPage({super.key});

  @override
  State<SkillAnalysisPage> createState() => _SkillAnalysisPageState();
}

class _SkillAnalysisPageState extends State<SkillAnalysisPage> {
  List<dynamic> roles = [];

  Map<String, dynamic>? selectedRole;

  final Set<String> selectedSkills = {};

  bool isLoadingRoles = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadRoles();
  }

  Future<void> loadRoles() async {
    try {
      final data = await ApiService.getRoles();

      if (!mounted) return;

      setState(() {
        roles = data;

        if (roles.isNotEmpty) {
          selectedRole = roles.first;
        }

        isLoadingRoles = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingRoles = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load roles: $e'),
        ),
      );
    }
  }

  List<String> get availableSkills {
    if (selectedRole == null) {
      return [];
    }

    final skills = selectedRole!['skills'] as List<dynamic>;

    return skills
        .map((skill) => skill['name'].toString())
        .toList();
  }

  Future<void> analyzeSkills() async {
    if (selectedRole == null) {
      return;
    }

    if (selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one skill.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.analyzeSkills(
        targetRole: selectedRole!['name'],
        skills: selectedSkills.toList(),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            matchScore: result.matchScore,
            matchedSkills: List<String>.from(
              result.matchedSkills,
            ),
            missingSkills: List<String>.from(
              result.missingSkills,
            ),
            recommendations: List<String>.from(
              result.recommendations,
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to analyze skills: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Analysis'),
        centerTitle: true,
      ),
      body: isLoadingRoles
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analyze Your Skills',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Choose your target career and select '
                  'the skills you already have.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 28),

            const Text(
              'Target Role',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<Map<String, dynamic>>(
              initialValue: selectedRole,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select a role',
              ),
              items: roles.map((role) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: role,
                  child: Text(role['name']),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedRole = value;
                    selectedSkills.clear();
                  });
                }
              },
            ),

            const SizedBox(height: 28),

            const Text(
              'Your Skills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            if (availableSkills.isEmpty)
              const Text(
                'No skills available for this role.',
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableSkills.map((skill) {
                  final isSelected =
                  selectedSkills.contains(skill);

                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedSkills.add(skill);
                        } else {
                          selectedSkills.remove(skill);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : analyzeSkills,
                child: isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Analyze Skills',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
