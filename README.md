# Korva Engine

A landscape-only Flutter companion app for starting and managing Korva Engine
projects, targeting Android 15 (SDK 35).

## ⚠️ Before you run it — required one-time setup

This zip contains everything Claude can hand-author as text: all Dart
source, assets, and a fully customized `android/` configuration. It
**cannot** contain two things, because they're machine-generated binaries,
not text Claude can write:

1. The Gradle wrapper executable (`gradlew`, `gradlew.bat`,
   `gradle/wrapper/gradle-wrapper.jar`)
2. `android/local.properties` (points at *your* local Flutter SDK path)

Both are generic — identical across any Flutter project on the same
Flutter version — so the fix is to borrow them from a scratch project:

```bash
# 1. Unzip this project
unzip korva_engine.zip && cd korva_engine

# 2. Generate a throwaway project elsewhere, just to harvest its wrapper
flutter create --platforms=android /tmp/scratch

# 3. Copy the generic wrapper files into this project (these three paths
#    are NOT specific to any project/package name, so this is always safe)
cp -r /tmp/scratch/android/gradle android/gradle
cp /tmp/scratch/android/gradlew android/gradlew
cp /tmp/scratch/android/gradlew.bat android/gradlew.bat
chmod +x android/gradlew

# 4. Get packages and run (landscape device/emulator recommended)
flutter pub get
flutter run
```

`local.properties` doesn't need copying — Flutter/Android Studio writes it
automatically the first time you open or build the project.

Requires **Flutter 3.27+** (this project uses the `CardThemeData` /
`DialogThemeData` Material theme API introduced then). Built and verified
against Flutter 3.44 / AGP 8.7.3 / Kotlin 2.1.10 / Gradle 8.10.2.

## Project structure

```
lib/
  main.dart                    Landscape lock + app entrypoint
  theme/app_theme.dart         Colors, type, and component themes
  models/project.dart          Project data model + metadata JSON codec
  services/
    permission_service.dart    MANAGE_EXTERNAL_STORAGE wrapper
    project_repository.dart    All real filesystem operations
  screens/
    home_screen.dart           Orchestrates layout + all app actions
    editor_screen.dart         Placeholder "editor" destination
  widgets/
    left_control_panel.dart    Logo + Start Editing / Open Project
    right_projects_panel.dart  Recent Projects list
    project_card.dart          Single project row
    bottom_status_bar.dart     Save-directory status strip
    create_project_dialog.dart "Start Editing" modal
    storage_permission_dialog.dart  Pre-permission rationale dialog
    korva_logo.dart             Logo, with fallback if the asset is missing
android/                        Full SDK 35 config (see below)
assets/images/logo.png          Placeholder mark (swap in your own)
```

Projects are real folders on disk, each holding a `.korvaproject` JSON
metadata file that "Recent Projects" and "Open Project" read back — there's
no mock/fake data anywhere in the flow.

## Android 15 (SDK 35) configuration

- `compileSdk`, `targetSdk` = **35** in `android/app/build.gradle.kts`
- `minSdk` = 24 (adjust to taste — `MANAGE_EXTERNAL_STORAGE` only applies
  from API 30 up regardless)
- AGP 8.7.3 (documented ceiling: compileSdk 35), Kotlin 2.1.10, Gradle
  8.10.2 — a verified-compatible combination
- Legacy `READ/WRITE_EXTERNAL_STORAGE` are declared with `maxSdkVersion`
  so they only apply pre-Android 11; `INTERNET` is scoped to debug/profile
  manifests only (needed for hot reload, not shipped in release)

## Storage permission flow

`Permission.manageExternalStorage` (via `permission_handler`) is requested
the first time the person taps **Start Editing** or **Open Project** —
never on launch — and only after `StoragePermissionDialog` explains why,
per the brief's requirement for an explanation dialog before the OS
prompt. Denial is handled gracefully (folders still save to app-private
storage) and permanent denial routes to `openAppSettings()`.

**Before publishing on Google Play**, note that `MANAGE_EXTERNAL_STORAGE`
is a restricted permission: Play's policy explicitly does *not* accept "the
user picks a folder in a dialog" as sufficient justification on its own —
that's expected to go through the Storage Access Framework instead (which
is what the "Change Path" / "Open Project" pickers already use via
`file_picker`, needing no special permission). If Korva Engine's broader
file management is core to the app, you'll complete Play's Permissions
Declaration Form; otherwise consider dropping this permission and relying
on SAF alone. Full policy:
https://support.google.com/googleplay/android-developer/answer/10467955
(This note also lives as a comment in `permission_service.dart`.)

## Design direction

Dark graphite surfaces, a warm brass accent, and monospaced paths/dates —
an "instrument panel" feel rather than a generic dark-mode-plus-neon-accent
look. Swap tokens in `AppColors`/`AppTheme` (`lib/theme/app_theme.dart`) to
re-theme; every screen reads from there rather than hardcoding colors.

## Swapping in your own logo

Drop your real `logo.png` into `assets/images/` (overwriting the generated
placeholder). No code changes needed — `KorvaLogo` already points at that
path, and falls back to a drawn monogram if the file is ever missing.

## Customizing the package name

`com.korva.engine` appears in three places if you rename it:
`android/app/build.gradle.kts` (`namespace`, `applicationId`),
`android/app/src/main/AndroidManifest.xml` (implicitly, via package),
and the folder + `package` line in `MainActivity.kt`.
