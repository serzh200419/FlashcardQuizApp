# Files Created - Flashcard Quiz App

This document lists all files created for the Flashcard Quiz App project.

## Configuration Files

- `pubspec.yaml` - Flutter project configuration with all dependencies
- `.gitignore` - Git ignore file for Flutter projects
- `analysis_options.yaml` - Dart/Flutter linting configuration
- `README.md` - Comprehensive project documentation

## Main Application

- `lib/main.dart` - App entry point with navigation setup and provider configuration

## Models (`lib/models/`)

- `lib/models/deck.dart` - Deck data model
- `lib/models/flashcard.dart` - Flashcard data model with study statistics
- `lib/models/quiz_result.dart` - Quiz result data model

## Services (`lib/services/`)

- `lib/services/storage_service.dart` - Local data persistence using SharedPreferences
- `lib/services/notification_service.dart` - Daily reminder notifications

## Providers (`lib/providers/`)

- `lib/providers/deck_provider.dart` - State management for decks
- `lib/providers/flashcard_provider.dart` - State management for flashcards
- `lib/providers/quiz_provider.dart` - State management for quiz sessions

## Widgets (`lib/widgets/`)

- `lib/widgets/deck_card.dart` - Reusable deck card component
- `lib/widgets/flashcard_widget.dart` - Flashcard display component
- `lib/widgets/primary_button.dart` - Custom primary button widget
- `lib/widgets/confirm_dialog.dart` - Confirmation dialog widget

## Screens (`lib/screens/`)

- `lib/screens/home_screen.dart` - Welcome/home screen with overview
- `lib/screens/deck_list_screen.dart` - List of all flashcard decks
- `lib/screens/add_edit_deck_screen.dart` - Create/edit deck form
- `lib/screens/flashcard_list_screen.dart` - List of flashcards in a deck
- `lib/screens/add_edit_flashcard_screen.dart` - Create/edit flashcard form
- `lib/screens/quiz_screen.dart` - Interactive quiz mode
- `lib/screens/statistics_screen.dart` - Statistics and progress tracking

## Utils (`lib/utils/`)

- `lib/utils/constants.dart` - App-wide constants
- `lib/utils/helpers.dart` - Utility functions (date formatting, etc.)

## Assets

- `assets/images/.gitkeep` - Placeholder for image assets
- `assets/fonts/.gitkeep` - Placeholder for custom fonts

## Total Files

- **Configuration**: 4 files
- **Dart Source Files**: 22 files
- **Asset Placeholders**: 2 files
- **Total**: 28 files

## Dependencies Installed

All dependencies have been installed via `flutter pub get`:
- provider (^6.1.1)
- shared_preferences (^2.2.2)
- sqflite (^2.3.0)
- flutter_local_notifications (^16.3.0)
- intl (^0.18.1)
- path (^1.8.3)
- timezone (^0.9.2)

## Project Status

✅ All files created
✅ All dependencies installed
✅ No linter errors
✅ Ready to run

