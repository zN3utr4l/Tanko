import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        padding: const EdgeInsets.all(12),
        children: [
          _DiagnosticTile(
            icon: Icons.price_check_outlined,
            title: 'Prezzi carburante MIMIT',
            subtitle: 'Dataset ufficiale giornaliero prezzi/anagrafica',
            status: _statuses['mimit'],
            onTap: () => _run('mimit', () async {
              final ok = await ref.read(mimitFuelPriceLookupProvider).ping();
              return ok
                  ? const _Status.ok('CSV raggiungibile')
                  : const _Status.fail('Dataset non raggiungibile');
            }),
          ),
          _DiagnosticTile(
            icon: Icons.local_gas_station_outlined,
            title: 'Distributori OpenStreetMap',
            subtitle: settings?.stationOnlineLookupEnabled == false
                ? 'Disattivato nelle impostazioni'
                : 'Test Overpass su coordinate campione',
            status: _statuses['overpass'],
            onTap: settings?.stationOnlineLookupEnabled == false
                ? null
                : () => _run('overpass', () async {
                    final rows = await ref
                        .read(stationLookupServiceProvider)
                        .nearby(41.9028, 12.4964, radiusMeters: 500);
                    return rows.isEmpty
                        ? const _Status.fail('Nessun dato o timeout')
                        : _Status.ok('${rows.length} risultati');
                  }),
          ),
          _DiagnosticTile(
            icon: Icons.directions_car_outlined,
            title: 'Catalogo allestimenti online',
            subtitle: settings?.vehicleOnlineLookupEnabled == false
                ? 'Disattivato nelle impostazioni'
                : 'Test non autorevole su Fiat Panda',
            status: _statuses['carapi'],
            onTap: settings?.vehicleOnlineLookupEnabled == false
                ? null
                : () => _run('carapi', () async {
                    final rows = await ref
                        .read(carApiCatalogLookupProvider)
                        .trims(make: 'Fiat', model: 'Panda');
                    return rows.isEmpty
                        ? const _Status.fail('Nessun allestimento trovato')
                        : _Status.ok('${rows.length} allestimenti');
                  }),
          ),
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
    return Card(
      child: ListTile(
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
      ),
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
