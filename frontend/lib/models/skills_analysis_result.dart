class SkillAnalysisResult {
  final int matchScore;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final List<String> recommendations;

  SkillAnalysisResult({
    required this.matchScore,
    required this.matchedSkills,
    required this.missingSkills,
    required this.recommendations,
  });

  factory SkillAnalysisResult.fromJson(Map<String, dynamic> json) {
    return SkillAnalysisResult(
      matchScore: json['match_score'] ?? 0,
      matchedSkills: List<String>.from(
        json['matched_skills'] ?? [],
      ),
      missingSkills: List<String>.from(
        json['missing_skills'] ?? [],
      ),
      recommendations: List<String>.from(
        json['recommendations'] ?? [],
      ),
    );
  }
}
