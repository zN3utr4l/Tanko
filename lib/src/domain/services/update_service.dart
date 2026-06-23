import '../models/app_release.dart';

class UpdateCheckException implements Exception {
  const UpdateCheckException(this.statusCode);

  final int statusCode;

  @override
  String toString() {
    if (statusCode == 403) {
      return 'Limite richieste GitHub raggiunto (HTTP 403). Riprova più tardi.';
    }
    return 'Controllo aggiornamenti non riuscito (HTTP $statusCode)';
  }
}

abstract class UpdateService {
  Future<AppRelease?> checkForUpdate(String currentVersion);

  Future<void> downloadAndInstall(
    AppRelease release, {
    void Function(double progress)? onProgress,
  });
}
