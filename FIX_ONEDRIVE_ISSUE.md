# Fix OneDrive File Locking Issue

## The Problem
Your project is in OneDrive (`OneDrive\Documentos`), which syncs files and locks them, preventing Flutter from accessing build directories.

## Solution: Exclude Build Folders from OneDrive Sync

### Step-by-Step Fix:

1. **Right-click on your project folder** (`FlashcardQuizApp`)
   - Go to: `OneDrive\Documentos\FlashcardQuizApp`
   
2. **Select "Always keep on this device"** (Optional - ensures files stay local)

3. **Add folders to OneDrive exclusion list:**

   Open File Explorer and navigate to your project folder, then:
   
   - Right-click on the `build` folder (if it exists)
   - Go to Properties → Advanced
   - Check "This folder only" → OK
   
   OR use the better method below:

### Method 2: Use OneDrive Settings (Recommended)

1. **Open OneDrive Settings:**
   - Click OneDrive icon in system tray
   - Click Settings (gear icon)
   - Go to "Sync and backup" → "Advanced settings"

2. **Add these folders to "Files on demand" exclusions:**
   - `build/`
   - `.dart_tool/`
   - `.flutter-plugins`
   - `pubspec.lock`

### Method 3: Create .onedriveignore File (Best Long-term)

Create a file named `.onedriveignore` in your project root with:

```
build/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
pubspec.lock
ios/Pods/
android/.gradle/
*.iml
.DS_Store
```

---

## Alternative: Move Project Outside OneDrive (Recommended for Development)

**This is the BEST solution for Flutter development:**

1. **Create a new folder outside OneDrive:**
   ```
   C:\Projects\FlashcardQuizApp
   ```
   or
   ```
   C:\Dev\FlashcardQuizApp
   ```

2. **Move your entire project folder there:**
   - Close IDE/terminal
   - Cut and paste the entire `FlashcardQuizApp` folder
   - Open from new location

3. **Run Flutter again:**
   ```bash
   cd C:\Projects\FlashcardQuizApp
   flutter pub get
   flutter run -d chrome
   ```

---

## Quick Fix: Pause OneDrive Temporarily

1. Right-click OneDrive icon in system tray
2. Click "Pause syncing" → "2 hours"
3. Run your Flutter commands
4. Resume syncing when done

---

## After Fixing - Try Again

Once you've done one of the above:

```bash
flutter clean
flutter pub get
flutter run -d chrome
```

---

**Recommendation:** Move the project outside OneDrive for the best development experience. OneDrive syncing can cause issues with build tools, git, and development workflows.

