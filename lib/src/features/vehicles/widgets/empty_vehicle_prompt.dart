import 'package:flutter/material.dart';
import '../add_vehicle_wizard_screen.dart';

/// Shown on every vehicle-scoped screen when no vehicle exists yet.
///
/// The whole area is tappable: a tap anywhere — not just the button — opens the
/// Add-Vehicle wizard, so the first-run "add a vehicle to start" screen leads
/// straight into onboarding.
class EmptyVehiclePrompt extends StatelessWidget {
  const EmptyVehiclePrompt({super.key});

  void _open(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => const AddVehicleWizardScreen()));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _open(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.directions_car_outlined,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Aggiungi un veicolo per iniziare',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Tocca lo schermo per crearne uno.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _open(context),
                icon: const Icon(Icons.add),
                label: const Text('Nuovo veicolo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
