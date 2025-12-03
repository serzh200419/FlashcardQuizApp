# Flashcard Quiz App 📚

A fully functional Flutter application for creating, managing, and studying flashcards with quiz functionality, statistics tracking, and daily study reminders.

## Features

- **Deck Management**: Create, edit, and delete flashcard decks
- **Flashcard Management**: Add, edit, and delete flashcards within decks
- **Interactive Quiz Mode**: Study flashcards with self-check functionality
- **Statistics Tracking**: View study statistics, accuracy, and quiz results
- **Local Persistence**: All data is stored locally using SharedPreferences
- **Daily Reminders**: Get notified daily to study your flashcards
- **Beautiful UI**: Modern, polished interface with smooth animations

## Project Structure

```
lib/
├── main.dart                          # App entry point with navigation setup
├── screens/
│   ├── home_screen.dart              # Welcome screen with overview
│   ├── deck_list_screen.dart         # List of all decks
│   ├── add_edit_deck_screen.dart     # Create/edit deck form
│   ├── flashcard_list_screen.dart    # List of flashcards in a deck
│   ├── add_edit_flashcard_screen.dart # Create/edit flashcard form
│   ├── quiz_screen.dart              # Interactive quiz mode
│   └── statistics_screen.dart        # Statistics and progress tracking
├── widgets/
│   ├── deck_card.dart                # Reusable deck card component
│   ├── flashcard_widget.dart         # Flashcard display component
│   ├── primary_button.dart           # Custom button widget
│   └── confirm_dialog.dart           # Confirmation dialog widget
├── models/
│   ├── deck.dart                     # Deck data model
│   ├── flashcard.dart                # Flashcard data model
│   └── quiz_result.dart              # Quiz result data model
├── providers/
│   ├── deck_provider.dart            # State management for decks
│   ├── flashcard_provider.dart       # State management for flashcards
│   └── quiz_provider.dart            # State management for quiz sessions
├── services/
│   ├── storage_service.dart          # Local data persistence
│   └── notification_service.dart     # Daily reminder notifications
└── utils/
    ├── constants.dart                # App-wide constants
    └── helpers.dart                  # Utility functions

assets/
├── images/                           # Image assets (placeholder)
└── fonts/                            # Custom fonts (placeholder)
```

## Dependencies

- **provider**: State management
- **shared_preferences**: Local data persistence
- **sqflite**: Additional database support (optional)
- **flutter_local_notifications**: Daily study reminders
- **intl**: Date/time formatting
- **timezone**: Timezone support for notifications
- **path**: Path manipulation utilities

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode (for mobile development)
- Android emulator or iOS simulator, or a physical device

### Installation

1. **Clone the repository** (if applicable) or navigate to the project directory:
   ```bash
   cd FlashcardQuizApp
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

   Or run on a specific device:
   ```bash
   flutter run -d <device-id>
   ```

### Running on Android Emulator

1. Open Android Studio
2. Start an Android emulator
3. Run `flutter run` in the terminal

### Running on iOS Simulator (macOS only)

1. Open Xcode
2. Start an iOS simulator
3. Run `flutter run` in the terminal

### Running on Physical Device

1. Enable Developer Mode on your device
2. Connect your device via USB
3. Run `flutter devices` to verify connection
4. Run `flutter run` to deploy to your device

## Usage Guide

### Creating a Deck

1. Tap "My Decks" from the home screen
2. Tap the "+ Add Deck" button
3. Enter a deck title
4. Tap "Create Deck"

### Adding Flashcards

1. Open a deck from the deck list
2. Tap the "+ Add Flashcard" button
3. Enter the question and answer
4. Tap "Create Flashcard"

### Taking a Quiz

1. Open a deck with flashcards
2. Tap "Start Quiz" button
3. Read the question and tap "Show Answer"
4. Mark your answer as "Correct" or "Incorrect"
5. Continue through all questions
6. View your results at the end

### Viewing Statistics

1. Tap "Statistics" from the home screen
2. View your overall statistics:
   - Total decks and flashcards
   - Cards studied
   - Overall accuracy
   - Recent quiz results

## Features in Detail

### State Management

The app uses **Provider** for efficient state management:
- `DeckProvider`: Manages deck creation, updates, and deletion
- `FlashcardProvider`: Manages flashcard operations and study tracking
- `QuizProvider`: Handles quiz session state and progress

### Local Persistence

All data is persisted locally using **SharedPreferences**:
- Decks are saved as JSON
- Flashcards are saved with study statistics
- Quiz results are stored for statistics tracking

### Notifications

The app schedules daily study reminders:
- Default time: 9:00 AM
- Configurable time (can be extended)
- Reminder appears even when app is closed

### Navigation

Uses Flutter's named routes:
- `/` - Home Screen
- `/deckList` - Deck List
- `/addDeck` - Add/Edit Deck
- `/flashcards` - Flashcard List
- `/addFlashcard` - Add/Edit Flashcard
- `/quiz` - Quiz Screen
- `/statistics` - Statistics Screen

## Code Quality

- **Modular Structure**: Clear separation of concerns
- **Reusable Widgets**: Components can be reused across screens
- **Error Handling**: Try-catch blocks with user-friendly error messages
- **Validation**: Form validation for user inputs
- **Comments**: Well-documented code with clear comments

## Troubleshooting

### Common Issues

1. **Dependencies not installing**
   - Run `flutter clean` then `flutter pub get`

2. **Notifications not working**
   - Check device notification permissions
   - Verify timezone settings

3. **Data not persisting**
   - Check SharedPreferences permissions
   - Verify storage permissions on device

4. **App crashes on startup**
   - Check Flutter and Dart SDK versions
   - Ensure all dependencies are compatible

## Future Enhancements

Potential features for future versions:
- [ ] Cloud sync across devices
- [ ] Multiple choice quiz mode
- [ ] Spaced repetition algorithm
- [ ] Card categories and tags
- [ ] Export/import flashcards
- [ ] Dark mode theme
- [ ] Search functionality
- [ ] Card difficulty levels

## License

This project is open source and available for personal and educational use.

## Contributing

Contributions, issues, and feature requests are welcome!

## Support

For support, please open an issue in the repository or contact the development team.

---

**Happy Studying! 📖✨**
