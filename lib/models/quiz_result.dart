class QuizResult {
  final String id;
  final String deckId;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime completedAt;

  QuizResult({
    required this.id,
    required this.deckId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completedAt,
  });

  double get accuracy {
    if (totalQuestions == 0) return 0.0;
    return (correctAnswers / totalQuestions) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deckId': deckId,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] as String,
      deckId: json['deckId'] as String,
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }
}

