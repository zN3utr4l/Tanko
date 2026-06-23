import 'dart:convert';

import 'package:carburo/src/data/update/github_update_service.dart';
import 'package:carburo/src/domain/services/update_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response _jsonResponse(Map<String, dynamic> body, {int status = 200}) {
  return http.Response(
    jsonEncode(body),
    status,
    headers: {'content-type': 'application/json'},
  );
}

void main() {
  group('GitHubUpdateService.checkForUpdate', () {
    test('returns the apk release when remote is newer', () async {
      final client = MockClient(
        (_) async => _jsonResponse({
          'tag_name': 'v0.5.0',
          'assets': [
            {
              'name': 'carburo-v0.5.0.apk',
              'browser_download_url': 'https://example.com/carburo.apk',
              'size': 99,
            },
          ],
        }),
      );

      final release = await GitHubUpdateService(
        client: client,
      ).checkForUpdate('0.4.0');

      expect(release, isNotNull);
      expect(release!.version, '0.5.0');
      expect(release.apkUrl, 'https://example.com/carburo.apk');
      expect(release.sizeBytes, 99);
    });

    test('returns null when remote is not newer', () async {
      final client = MockClient(
        (_) async => _jsonResponse({
          'tag_name': 'v0.5.0',
          'assets': [
            {
              'name': 'carburo-v0.5.0.apk',
              'browser_download_url': 'https://example.com/carburo.apk',
              'size': 99,
            },
          ],
        }),
      );

      expect(
        await GitHubUpdateService(client: client).checkForUpdate('0.5.0'),
        isNull,
      );
    });

    test('throws UpdateCheckException on non-200', () {
      final client = MockClient((_) async => _jsonResponse({}, status: 403));

      expect(
        GitHubUpdateService(client: client).checkForUpdate('0.4.0'),
        throwsA(isA<UpdateCheckException>()),
      );
    });

    test('sends the GitHub JSON accept header', () async {
      String? accept;
      final client = MockClient((request) async {
        accept = request.headers['Accept'];
        return _jsonResponse({'tag_name': 'v0.4.0', 'assets': <Object?>[]});
      });

      await GitHubUpdateService(client: client).checkForUpdate('0.4.0');

      expect(accept, 'application/vnd.github+json');
    });
  });
}
