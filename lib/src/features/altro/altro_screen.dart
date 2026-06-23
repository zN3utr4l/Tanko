import 'package:flutter/material.dart';
import '../bollo/bollo_calculator_screen.dart';
import '../movimenti/movimenti_screen.dart';
import '../settings/settings_screen.dart';
import '../vehicles/vehicles_screen.dart';

class AltroScreen extends StatelessWidget {
  const AltroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void go(Widget screen) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    return Scaffold(
      appBar: AppBar(title: const Text('Altro')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Veicoli'),
            onTap: () => go(const VehiclesScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Movimenti'),
            subtitle: const Text('Rifornimenti e spese'),
            onTap: () => go(const MovimentiScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.calculate_outlined),
            title: const Text('Calcolatore bollo'),
            subtitle: const Text('Stima offline da kW e classe Euro'),
            onTap: () => go(const BolloCalculatorScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Impostazioni'),
            onTap: () => go(const SettingsScreen()),
          ),
        ],
      ),
    );
  }
}
