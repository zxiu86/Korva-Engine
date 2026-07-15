/// Validation helpers for user-entered project data.
class ProjectValidators {
  ProjectValidators._();

  /// Letters, numbers, spaces, hyphens and underscores only — safe for
  /// folder names across Android/Windows/macOS file systems.
  static final RegExp _allowedCharacters = RegExp(r'^[a-zA-Z0-9 _\-]+$');

  /// Validates a project name. Returns an error message, or null if the
  /// value is valid.
  static String? projectName(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) {
      return 'Project name cannot be empty.';
    }
    if (trimmed.length > 48) {
      return 'Keep it under 48 characters.';
    }
    if (!_allowedCharacters.hasMatch(trimmed)) {
      return 'Only letters, numbers, spaces, - and _ are allowed.';
    }
    return null;
  }
}
