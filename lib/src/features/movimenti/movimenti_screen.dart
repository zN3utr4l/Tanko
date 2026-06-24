import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/formatters.dart';
import '../../domain/models/expense.dart';
import '../../domain/models/fill_up.dart';
import '../../providers.dart';
import '../dashboard/dashboard_providers.dart';
import '../expenses/expense_form_screen.dart';
import '../expenses/expense_providers.dart';
import '../fillups/fill_up_form_screen.dart';
import '../fillups/fillup_providers.dart';
import '../vehicles/widgets/empty_vehicle_prompt.dart';

enum _Filter { all, fuel, expense }

class MovimentiScreen extends ConsumerStatefulWidget {
  const MovimentiScreen({super.key});

  @override
  ConsumerState<MovimentiScreen> createState() => _MovimentiScreenState();
}

class _MovimentiScreenState extends ConsumerState<MovimentiScreen> {
  _Filter _filter = _Filter.all;
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete({
    required String title,
    required Future<void> Function() delete,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: const Text('Operazione non reversibile.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await delete();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleAsync = ref.watch(dashboardVehicleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Movimenti')),
      body: vehicleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
        data: (vehicle) {
          if (vehicle == null) {
            return const EmptyVehiclePrompt();
          }
          final fills = ref.watch(fillUpsProvider(vehicle.id));
          final expenses = ref.watch(expensesForVehicleProvider(vehicle.id));
          final cats = ref.watch(allCategoriesProvider);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    SegmentedButton<_Filter>(
                      segments: const [
                        ButtonSegment(value: _Filter.all, label: Text('Tutti')),
                        ButtonSegment(
                          value: _Filter.fuel,
                          label: Text('Carburante'),
                        ),
                        ButtonSegment(
                          value: _Filter.expense,
                          label: Text('Spese'),
                        ),
                      ],
                      selected: {_filter},
                      onSelectionChanged: (s) =>
                          setState(() => _filter = s.first),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _query,
                      decoration: const InputDecoration(
                        labelText: 'Cerca',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: (fills.isLoading || expenses.isLoading)
                    ? const Center(child: CircularProgressIndicator())
                    : _list(
                        context,
                        ref,
                        vehicle.id,
                        fills.asData?.value ?? const [],
                        expenses.asData?.value ?? const [],
                        {
                          for (final c in cats.asData?.value ?? const [])
                            c.id: c.name,
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _list(
    BuildContext context,
    WidgetRef ref,
    int vehicleId,
    List<FillUp> fills,
    List<Expense> expenses,
    Map<int, String> catName,
  ) {
    final rows = <_Row>[
      if (_filter != _Filter.expense)
        for (final f in fills)
          _Row(
            date: f.date,
            icon: Icons.local_gas_station,
            color: Colors.teal,
            title: 'Rifornimento',
            subtitle: f.liters == null ? null : fmtLiters(f.liters!),
            amount: f.amount,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    FillUpFormScreen(vehicleId: vehicleId, initial: f),
              ),
            ),
            onDelete: () => _confirmDelete(
              title: 'Eliminare il rifornimento?',
              delete: () async {
                await ref.read(fillUpRepositoryProvider).delete(f.id);
                ref.invalidate(fillUpsProvider(vehicleId));
              },
            ),
          ),
      if (_filter != _Filter.fuel)
        for (final e in expenses)
          _Row(
            date: e.date,
            icon: Icons.payments,
            color: Colors.amber.shade800,
            title: catName[e.categoryId] ?? 'Spesa',
            subtitle: e.description,
            amount: e.amount,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    ExpenseFormScreen(vehicleId: vehicleId, initial: e),
              ),
            ),
            onDelete: () => _confirmDelete(
              title: 'Eliminare la spesa?',
              delete: () async {
                await ref.read(expenseRepositoryProvider).delete(e.id);
                ref.invalidate(expensesForVehicleProvider(vehicleId));
              },
            ),
          ),
    ]..sort((a, b) => b.date.compareTo(a.date));
    final q = _query.text.trim().toLowerCase();
    final filtered = q.isEmpty
        ? rows
        : rows
              .where(
                (r) =>
                    r.title.toLowerCase().contains(q) ||
                    (r.subtitle?.toLowerCase().contains(q) ?? false),
              )
              .toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('Nessun movimento.'));
    }
    return ListView(
      children: [
        for (final r in filtered)
          ListTile(
            leading: Icon(r.icon, color: r.color),
            title: Text(r.title),
            subtitle: Text(
              [
                fmtDate(r.date),
                if (r.subtitle != null) r.subtitle!,
              ].join(' · '),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fmtEuro(r.amount),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  tooltip: 'Elimina',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: r.onDelete,
                ),
              ],
            ),
            onLongPress: r.onDelete,
            onTap: r.onTap,
          ),
      ],
    );
  }
}

class _Row {
  _Row({
    required this.date,
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
    required this.onTap,
    required this.onDelete,
    this.subtitle,
  });
  final DateTime date;
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final double amount;
  final VoidCallback onTap;
  final VoidCallback onDelete;
}
