import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/deck_provider.dart';
import 'providers/flashcard_provider.dart';
import 'providers/quiz_provider.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
import 'screens/deck_list_screen.dart';
import 'screens/add_edit_deck_screen.dart';
import 'screens/flashcard_list_screen.dart';
import 'screens/add_edit_flashcard_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/statistics_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.scheduleDailyReminder(hour: 9, minute: 0);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeckProvider()),
        ChangeNotifierProvider(create: (_) => FlashcardProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(AppConstants.primaryColorValue),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(AppConstants.primaryColorValue),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/deckList': (context) => const DeckListScreen(),
          '/addDeck': (context) => const AddEditDeckScreen(),
          '/flashcards': (context) => const FlashcardListScreen(),
          '/addFlashcard': (context) => const AddEditFlashcardScreen(),
          '/quiz': (context) => const QuizScreen(),
          '/statistics': (context) => const StatisticsScreen(),
        },
      ),
    );
  }
}

