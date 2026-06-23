import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/app_release.dart';
import '../../providers.dart';

part 'update_providers.g.dart';

@Riverpod(keepAlive: true)
class AvailableUpdate extends _$AvailableUpdate {
  @override
  AppRelease? build() => null;

  void set(AppRelease? release) => state = release;
}

Future<void> startupUpdateCheck(WidgetRef ref) async {
  final prefs = ref.read(updatePrefsProvider);
  final lastCheck = await prefs.lastCheck();
  if (!shouldCheck(lastCheck, DateTime.now(), const Duration(days: 1))) {
    return;
  }

  final currentVersion = await ref.read(currentVersionProvider.future);
  final release = await ref
      .read(updateServiceProvider)
      .checkForUpdate(currentVersion);
  await prefs.markChecked(DateTime.now());
  if (release != null) {
    ref.read(availableUpdateProvider.notifier).set(release);
  }
}

Future<void> showUpdateAvailableDialog(
  BuildContext context,
  WidgetRef ref,
  AppRelease release,
) async {
  final wantsUpdate = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Aggiornamento disponibile'),
      content: Text('Carburo v${release.version} disponibile.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Più tardi'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.system_update),
          label: const Text('Aggiorna'),
        ),
      ],
    ),
  );
  if (wantsUpdate == true && context.mounted) {
    await showUpdateDownloadDialog(context, ref, release);
  }
}

Future<void> showUpdateDownloadDialog(
  BuildContext context,
  WidgetRef ref,
  AppRelease release,
) async {
  final progress = ValueNotifier<double?>(null);
  final messenger = ScaffoldMessenger.of(context);

  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Aggiornamento'),
        content: ValueListenableBuilder<double?>(
          valueListenable: progress,
          builder: (context, value, child) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: value),
              const SizedBox(height: 12),
              Text(value == null ? 'Download...' : '${(value * 100).round()}%'),
            ],
          ),
        ),
      ),
    ),
  );

  try {
    await ref
        .read(updateServiceProvider)
        .downloadAndInstall(
          release,
          onProgress: (value) => progress.value = value,
        );
  } catch (error) {
    messenger.showSnackBar(
      SnackBar(content: Text('Aggiornamento non riuscito: $error')),
    );
  } finally {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    progress.dispose();
  }
}
