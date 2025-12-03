import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/deck_provider.dart';
import '../providers/flashcard_provider.dart';
import '../services/storage_service.dart';
import '../models/quiz_result.dart';
import '../widgets/primary_button.dart';
import '../utils/helpers.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final StorageService _storageService = StorageService();
  List<QuizResult> _allResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _storageService.getQuizResults();
      setState(() {
        _allResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: Consumer2<DeckProvider, FlashcardProvider>(
                builder: (context, deckProvider, flashcardProvider, child) {
                  final totalDecks = deckProvider.totalDecks;
                  final totalFlashcards = flashcardProvider.totalFlashcards;
                  final totalQuizzes = _allResults.length;
                  final totalQuestionsAnswered = _allResults.fold<int>(
                    0,
                    (sum, result) => sum + result.totalQuestions,
                  );
                  final totalCorrectAnswers = _allResults.fold<int>(
                    0,
                    (sum, result) => sum + result.correctAnswers,
                  );
                  final overallAccuracy = totalQuestionsAnswered > 0
                      ? (totalCorrectAnswers / totalQuestionsAnswered) * 100
                      : 0.0;

                  // Calculate cards studied (unique flashcards that have been studied)
                  final studiedCards = flashcardProvider.flashcards
                      .where((fc) => fc.timesStudied > 0)
                      .length;

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Overall Statistics Card
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).primaryColor.withOpacity(0.7),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const Text(
                                  'Overall Statistics',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _StatItem(
                                      label: 'Decks',
                                      value: totalDecks.toString(),
                                      color: Colors.white,
                                    ),
                                    _StatItem(
                                      label: 'Flashcards',
                                      value: totalFlashcards.toString(),
                                      color: Colors.white,
                                    ),
                                    _StatItem(
                                      label: 'Quizzes',
                                      value: totalQuizzes.toString(),
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Study Statistics
                        const Text(
                          'Study Statistics',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.book,
                                title: 'Cards Studied',
                                value: studiedCards.toString(),
                                subtitle: 'out of $totalFlashcards',
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.quiz,
                                title: 'Questions Answered',
                                value: totalQuestionsAnswered.toString(),
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _StatCard(
                          icon: Icons.trending_up,
                          title: 'Overall Accuracy',
                          value: '${overallAccuracy.toStringAsFixed(1)}%',
                          subtitle: '$totalCorrectAnswers correct',
                          color: overallAccuracy >= 70 ? Colors.green : Colors.orange,
                          fullWidth: true,
                        ),
                        const SizedBox(height: 24),

                        // Recent Quiz Results
                        if (_allResults.isNotEmpty) ...[
                          const Text(
                            'Recent Quiz Results',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._allResults.reversed.take(5).map((result) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: result.accuracy >= 70
                                      ? Colors.green
                                      : Colors.orange,
                                  child: Text(
                                    '${result.accuracy.toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '${result.correctAnswers}/${result.totalQuestions} correct',
                                ),
                                subtitle: Text(
                                  Helpers.formatDateTime(result.completedAt),
                                ),
                                trailing: Icon(
                                  result.accuracy >= 70
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: result.accuracy >= 70
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            );
                          }).toList(),
                        ] else ...[
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.bar_chart,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No quiz results yet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Complete quizzes to see your statistics here!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color color;
  final bool fullWidth;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

