import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/form_section_card.dart';
import '../../providers.dart';

class OnlineDiagnosticsScreen extends ConsumerStatefulWidget {
  const OnlineDiagnosticsScreen({super.key});

  @override
  ConsumerState<OnlineDiagnosticsScreen> createState() =>
      _OnlineDiagnosticsScreenState();
}

class _OnlineDiagnosticsScreenState
    extends ConsumerState<OnlineDiagnosticsScreen> {
  final _statuses = <String, _Status>{};

  Future<void> _run(String key, Future<_Status> Function() action) async {
    setState(() => _statuses[key] = const _Status.loading());
    final status = await action();
    if (!mounted) return;
    setState(() => _statuses[key] = status);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(lookupSettingsProvider).asData?.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostica online')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FormSectionCard(
            title: 'Servizi online',
            children: [
              _DiagnosticTile(
                icon: Icons.price_check_outlined,
                title: 'Prezzi carburante MIMIT',
                subtitle: 'Dataset ufficiale giornaliero prezzi/anagrafica',
                status: _statuses['mimit'],
                onTap: () => _run('mimit', () async {
                  final ok = await ref
                      .read(mimitFuelPriceLookupProvider)
                      .ping();
                  return ok
                      ? const _Status.ok('CSV raggiungibile')
                      : const _Status.fail('Dataset non raggiungibile');
                }),
              ),
              const Divider(height: 1),
              _DiagnosticTile(
                icon: Icons.local_gas_station_outlined,
                title: 'Distributori OpenStreetMap',
                subtitle: settings?.stationOnlineLookupEnabled == false
                    ? 'Disattivato nelle impostazioni'
                    : 'Overpass su Roma EUR (raggio 3 km)',
                status: _statuses['overpass'],
                onTap: settings?.stationOnlineLookupEnabled == false
                    ? null
                    : () => _run('overpass', () async {
                        final result = await ref
                            .read(stationLookupServiceProvider)
                            .probe(41.8333, 12.4667, radiusMeters: 3000);
                        if (result.error != null) {
                          return _Status.fail(result.error!);
                        }
                        return result.count == 0
                            ? const _Status.fail('Nessun distributore nel raggio')
                            : _Status.ok('${result.count} distributori');
                      }),
              ),
              const Divider(height: 1),
              _DiagnosticTile(
                icon: Icons.directions_car_outlined,
                title: 'Catalogo allestimenti',
                subtitle: 'Catalogo offline (fallback online) · Fiat Panda',
                status: _statuses['carapi'],
                onTap: () => _run('carapi', () async {
                  // Offline-first: the bundled catalog is the authoritative
                  // source. Only fall back to the (key-gated) online API when
                  // the offline catalog has nothing.
                  final models = await ref
                      .read(catalogRepositoryProvider)
                      .models('Fiat');
                  final offline = models
                      .where((m) => m.name.toLowerCase() == 'panda')
                      .expand((m) => m.trims)
                      .map((t) => t.name)
                      .toSet();
                  if (offline.isNotEmpty) {
                    return _Status.ok('${offline.length} allestimenti (offline)');
                  }
                  if (settings?.vehicleOnlineLookupEnabled == false) {
                    return const _Status.fail(
                      'Nessun dato offline · online disattivato',
                    );
                  }
                  final online = await ref
                      .read(carApiCatalogLookupProvider)
                      .trims(make: 'Fiat', model: 'Panda');
                  return online.isEmpty
                      ? const _Status.fail('Richiede API key (online senza auth)')
                      : _Status.ok('${online.length} allestimenti (online)');
                }),
              ),
              const Divider(height: 1),
              _DiagnosticTile(
                icon: Icons.key_outlined,
                title: 'Openapi targa/RCA',
                subtitle: 'Il test non viene eseguito per evitare costi API',
                status: settings == null
                    ? null
                    : settings.openApiKey.trim().isEmpty
                    ? const _Status.fail('API key non configurata')
                    : const _Status.ok('API key configurata'),
              ),
              const Divider(height: 1),
              _DiagnosticTile(
                icon: Icons.system_update_outlined,
                title: 'Aggiornamenti GitHub',
                subtitle: settings?.updateChecksEnabled == false
                    ? 'Disattivato nelle impostazioni'
                    : 'Controlla release disponibili',
                status: _statuses['updates'],
                onTap: settings?.updateChecksEnabled == false
                    ? null
                    : () => _run('updates', () async {
                        final current = await ref.read(
                          currentVersionProvider.future,
                        );
                        final release = await ref
                            .read(updateServiceProvider)
                            .checkForUpdate(current);
                        return release == null
                            ? const _Status.ok('Nessun aggiornamento')
                            : _Status.ok('Disponibile ${release.version}');
                      }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiagnosticTile extends StatelessWidget {
  const _DiagnosticTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.status,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final _Status? status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final status = this.status;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        status == null ? subtitle : '$subtitle\n${status.message}',
      ),
      isThreeLine: status != null,
      trailing: status?.loading == true
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              status == null
                  ? Icons.play_arrow_outlined
                  : status.ok
                  ? Icons.check_circle
                  : Icons.error_outline,
              color: status == null
                  ? null
                  : status.ok
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
            ),
      onTap: status?.loading == true ? null : onTap,
    );
  }
}

class _Status {
  const _Status.ok(this.message) : ok = true, loading = false;
  const _Status.fail(this.message) : ok = false, loading = false;
  const _Status.loading()
    : ok = false,
      loading = true,
      message = 'Test in corso...';

  final bool ok;
  final bool loading;
  final String message;
}
