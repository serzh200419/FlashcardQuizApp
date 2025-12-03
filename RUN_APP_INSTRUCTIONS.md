# How to Run the App (OneDrive File Locking Issue)

## Problem
Your project is in OneDrive (`OneDrive\Documentos`), which can cause file locking issues when Flutter tries to build.

## Quick Solutions

### Solution 1: Run on Chrome (Recommended - Fastest)
Chrome/web doesn't need Windows build files, so it avoids the OneDrive locking issue:

```bash
flutter run -d chrome
```

### Solution 2: Move Project Outside OneDrive (Best Long-term)
1. Close this terminal/IDE
2. Move the entire `FlashcardQuizApp` folder to a location outside OneDrive, like:
   - `C:\Projects\FlashcardQuizApp`
   - `C:\Dev\FlashcardQuizApp`
   - Or any folder NOT synced by OneDrive
3. Open the project from the new location
4. Run: `flutter run -d chrome`

### Solution 3: Pause OneDrive Sync Temporarily
1. Right-click OneDrive icon in system tray
2. Click "Pause syncing" → "2 hours"
3. Try running the app again
4. Resume syncing when done

### Solution 4: Run on Android Emulator
Android emulator doesn't use Windows build files:

```bash
flutter emulators --launch Medium_Phone_API_36.0
flutter run
```

---

## Currently Trying: Running on Chrome

The app should work on Chrome even with OneDrive locking issues. Let's try it!

