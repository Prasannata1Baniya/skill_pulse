import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int matchScore;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final List<String> recommendations;

  const ResultPage({
    super.key,
    required this.matchScore,
    required this.matchedSkills,
    required this.missingSkills,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Analysis'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

// Header
            const Text(
              'Your Skill Pulse',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Here is your current skill match.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 28),

// Score Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'MATCH SCORE',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        '$matchScore%',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      LinearProgressIndicator(
                        value: matchScore / 100,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

// Matched Skills
            const Text(
              'Matched Skills',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (matchedSkills.isEmpty)
              const Text('No matching skills found.')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: matchedSkills.map((skill) {
                  return Chip(
                    avatar: const Icon(
                      Icons.check,
                      size: 18,
                    ),
                    label: Text(skill),
                  );
                }).toList(),
              ),

            const SizedBox(height: 30),

// Missing Skills
            const Text(
              'Skills to Improve',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (missingSkills.isEmpty)
              const Text(
                'Excellent! You have all the required skills.',
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: missingSkills.map((skill) {
                  return Chip(
                    avatar: const Icon(
                      Icons.warning_amber,
                      size: 18,
                    ),
                    label: Text(skill),
                  );
                }).toList(),
              ),

            const SizedBox(height: 30),

// Recommendations
            const Text(
              'Recommendations',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...recommendations.map(
                  (recommendation) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            recommendation,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

// Analyze Again
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Analyze Again',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
