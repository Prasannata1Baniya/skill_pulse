import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'result_page.dart';

class SkillAnalysisPage extends StatefulWidget {
  const SkillAnalysisPage({super.key});

  @override
  State<SkillAnalysisPage> createState() => _SkillAnalysisPageState();
}

class _SkillAnalysisPageState extends State<SkillAnalysisPage> {
  String selectedRole = 'Mobile Engineer';

  final List<String> roles = [
    'Mobile Engineer',
    'Backend Engineer',
    'Full Stack Engineer',
  ];

  final List<String> availableSkills = [
    'Dart',
    'Flutter',
    'State Management',
    'REST APIs',
    'Git',
    'Unit Testing',
    'Python',
    'Django',
    'SQL',
    'Docker',
    'Redis',
  ];

  final Set<String> selectedSkills = {};
 bool isLoading =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Pulse'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
              'Choose your target career and select the skills you already have.',
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

            DropdownButtonFormField<String>(
              initialValue: selectedRole,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select a role',
              ),
              items: roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedRole = value;
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

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableSkills.map((skill) {
                final isSelected = selectedSkills.contains(skill);

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
      onPressed: isLoading
          ? null
          : () async {
    if (selectedSkills.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text(
    'Please select at least one skill.',
    ),
    ),
    );
    return;
    }

    setState(() {
    isLoading = true;
    });

    try {
    final result = await ApiService.analyzeSkills(
    targetRole: selectedRole,
    skills: selectedSkills.toList(),
    );

    if (!context.mounted) return;

    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => ResultPage(
    matchScore: result['match_score'],
    matchedSkills: List<String>.from(
    result['matched_skills'],
    ),
    missingSkills: List<String>.from(
    result['missing_skills'],
    ),
    recommendations: List<String>.from(
    result['recommendations'],
    ),
    ),
    ),
    );
    } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(
    'Unable to analyze skills. Please try again.',
    ),
    ),
    );
    } finally {
    if (mounted) {
    setState(() {
    isLoading = false;
    });
    }
    }
    },
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

