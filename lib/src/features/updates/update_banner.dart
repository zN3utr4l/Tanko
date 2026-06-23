import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'update_providers.dart';

class UpdateBanner extends ConsumerWidget {
  const UpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final update = ref.watch(availableUpdateProvider);
    if (update == null) return const SizedBox.shrink();

    return MaterialBanner(
      leading: const Icon(Icons.system_update),
      content: Text('Carburo v${update.version} disponibile'),
      actions: [
        TextButton(
          onPressed: () => ref.read(availableUpdateProvider.notifier).set(null),
          child: const Text('Più tardi'),
        ),
        FilledButton.icon(
          onPressed: () => showUpdateDownloadDialog(context, ref, update),
          icon: const Icon(Icons.download),
          label: const Text('Aggiorna'),
        ),
      ],
    );
  }
}
