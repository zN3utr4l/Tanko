import 'package:carburo/src/domain/models/app_release.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isNewerVersion', () {
    test('higher major/minor/patch is newer', () {
      expect(isNewerVersion('0.5.0', '0.4.0'), isTrue);
      expect(isNewerVersion('1.0.0', '0.9.9'), isTrue);
      expect(isNewerVersion('0.4.1', '0.4.0'), isTrue);
    });

    test('equal or older is not newer', () {
      expect(isNewerVersion('0.4.0', '0.4.0'), isFalse);
      expect(isNewerVersion('0.3.9', '0.4.0'), isFalse);
    });

    test('tolerates a leading v and missing parts', () {
      expect(isNewerVersion('v0.5', '0.4.0'), isTrue);
      expect(isNewerVersion('0.4', '0.4.0'), isFalse);
    });
  });

  group('parseLatestRelease', () {
    test('picks the apk asset and strips the v from the tag', () {
      final release = parseLatestRelease({
        'tag_name': 'v0.5.0',
        'assets': [
          {
            'name': 'sha256.txt',
            'browser_download_url': 'https://example.com/s.txt',
            'size': 1,
          },
          {
            'name': 'carburo-v0.5.0.apk',
            'browser_download_url': 'https://example.com/c.apk',
            'size': 1234,
          },
        ],
      });

      expect(release, isNotNull);
      expect(release!.version, '0.5.0');
      expect(release.apkUrl, 'https://example.com/c.apk');
      expect(release.sizeBytes, 1234);
    });

    test('returns null when there is no tag or no apk asset', () {
      expect(parseLatestRelease({'assets': <Object?>[]}), isNull);
      expect(
        parseLatestRelease({'tag_name': 'v0.5.0', 'assets': <Object?>[]}),
        isNull,
      );
    });
  });

  group('shouldCheck', () {
    final now = DateTime(2026, 6, 23, 12);

    test('true when never checked', () {
      expect(shouldCheck(null, now, const Duration(days: 1)), isTrue);
    });

    test('true when older than the interval', () {
      expect(
        shouldCheck(
          now.subtract(const Duration(days: 2)),
          now,
          const Duration(days: 1),
        ),
        isTrue,
      );
    });

    test('false when within the interval', () {
      expect(
        shouldCheck(
          now.subtract(const Duration(hours: 2)),
          now,
          const Duration(days: 1),
        ),
        isFalse,
      );
    });
  });
}
