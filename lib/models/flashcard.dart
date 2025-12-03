class Flashcard {
  final String id;
  final String deckId;
  String question;
  String answer;
  int timesStudied;
  int timesCorrect;
  final DateTime createdAt;
  DateTime? updatedAt;

  Flashcard({
    required this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    this.timesStudied = 0,
    this.timesCorrect = 0,
    required this.createdAt,
    this.updatedAt,
  });

  double get accuracy {
    if (timesStudied == 0) return 0.0;
    return (timesCorrect / timesStudied) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deckId': deckId,
      'question': question,
      'answer': answer,
      'timesStudied': timesStudied,
      'timesCorrect': timesCorrect,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as String,
      deckId: json['deckId'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      timesStudied: json['timesStudied'] as int? ?? 0,
      timesCorrect: json['timesCorrect'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Flashcard copyWith({
    String? id,
    String? deckId,
    String? question,
    String? answer,
    int? timesStudied,
    int? timesCorrect,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Flashcard(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      timesStudied: timesStudied ?? this.timesStudied,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

