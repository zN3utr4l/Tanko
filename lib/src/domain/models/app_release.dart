class AppRelease {
  const AppRelease({
    required this.version,
    required this.apkUrl,
    required this.sizeBytes,
  });

  final String version;
  final String apkUrl;
  final int sizeBytes;
}

bool isNewerVersion(String candidate, String current) {
  final candidateParts = _parseVersion(candidate);
  final currentParts = _parseVersion(current);
  for (var i = 0; i < 3; i++) {
    if (candidateParts[i] > currentParts[i]) return true;
    if (candidateParts[i] < currentParts[i]) return false;
  }
  return false;
}

AppRelease? parseLatestRelease(Map<String, dynamic> json) {
  final tag = json['tag_name'] as String?;
  if (tag == null || tag.isEmpty) return null;

  final assets = json['assets'] as List<dynamic>? ?? const [];
  for (final asset in assets) {
    if (asset is! Map<String, dynamic>) continue;
    final name = asset['name'] as String?;
    final apkUrl = asset['browser_download_url'] as String?;
    if (name == null || apkUrl == null) continue;
    if (!name.toLowerCase().endsWith('.apk')) continue;

    return AppRelease(
      version: _stripLeadingV(tag),
      apkUrl: apkUrl,
      sizeBytes: (asset['size'] as int?) ?? 0,
    );
  }

  return null;
}

bool shouldCheck(DateTime? lastCheck, DateTime now, Duration interval) {
  if (lastCheck == null) return true;
  return now.difference(lastCheck) >= interval;
}

List<int> _parseVersion(String version) {
  final parts = _stripLeadingV(version).split('.');
  return List.generate(
    3,
    (index) => index < parts.length ? int.tryParse(parts[index]) ?? 0 : 0,
  );
}

String _stripLeadingV(String version) =>
    version.startsWith('v') || version.startsWith('V')
    ? version.substring(1)
    : version;
