import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/models/app_release.dart';
import '../../domain/services/update_service.dart';

class GitHubUpdateService implements UpdateService {
  GitHubUpdateService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  static const _owner = 'zN3utr4l';
  static const _repo = 'Carburo';

  @override
  Future<AppRelease?> checkForUpdate(String currentVersion) async {
    final response = await _client.get(
      Uri.parse('https://api.github.com/repos/$_owner/$_repo/releases/latest'),
      headers: {'Accept': 'application/vnd.github+json'},
    );
    if (response.statusCode != 200) {
      throw UpdateCheckException(response.statusCode);
    }

    final release = parseLatestRelease(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    if (release == null) return null;
    return isNewerVersion(release.version, currentVersion) ? release : null;
  }

  @override
  Future<void> downloadAndInstall(
    AppRelease release, {
    void Function(double progress)? onProgress,
  }) async {
    final request = http.Request('GET', Uri.parse(release.apkUrl));
    final response = await _client.send(request);
    if (response.statusCode != 200) {
      throw Exception('Download fallito: HTTP ${response.statusCode}');
    }

    final total = response.contentLength ?? release.sizeBytes;
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, 'carburo-update.apk'));
    final sink = file.openWrite();
    try {
      var received = 0;
      await for (final chunk in response.stream) {
        received += chunk.length;
        sink.add(chunk);
        if (total > 0) {
          onProgress?.call((received / total).clamp(0.0, 1.0));
        }
      }
    } finally {
      await sink.close();
    }

    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done) {
      throw Exception('Impossibile aprire installer: ${result.message}');
    }
  }
}
