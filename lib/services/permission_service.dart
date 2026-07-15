import 'package:permission_handler/permission_handler.dart';

/// Simplified, UI-friendly outcome of a storage permission check/request.
enum StorageAccess { granted, denied, permanentlyDenied }

/// Wraps `permission_handler` calls for the broad "All files access"
/// permission (`MANAGE_EXTERNAL_STORAGE`), which is how Android 11+
/// (API 30+) — including Android 15 / API 35 — gates unrestricted access
/// to shared storage outside scoped, app-specific directories.
///
/// IMPORTANT — Google Play policy note:
/// Play restricts `MANAGE_EXTERNAL_STORAGE` to apps whose *core* function
/// is broad file management (file managers, backup tools, anti-virus,
/// document managers) and explicitly does **not** treat "the user picks a
/// folder in a dialog" as sufficient justification on its own — that use
/// case is expected to go through the Storage Access Framework instead
/// (already what `file_picker`'s directory picker uses in this app, and
/// it needs no special permission). Before publishing Korva Engine on
/// Play, confirm this permission is actually required for the app's core
/// functionality and complete the Permissions Declaration Form, or scope
/// the app back to SAF-only access. See:
/// https://support.google.com/googleplay/android-developer/answer/10467955
class PermissionService {
  PermissionService._();

  static Future<StorageAccess> checkStatus() async {
    final status = await Permission.manageExternalStorage.status;
    return _map(status);
  }

  static Future<StorageAccess> request() async {
    final status = await Permission.manageExternalStorage.request();
    return _map(status);
  }

  static Future<bool> openSettings() => openAppSettings();

  static StorageAccess _map(PermissionStatus status) {
    if (status.isGranted) return StorageAccess.granted;
    if (status.isPermanentlyDenied) return StorageAccess.permanentlyDenied;
    return StorageAccess.denied;
  }
}
