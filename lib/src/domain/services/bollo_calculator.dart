/// Italian emission class — libretto (carta di circolazione) field **V.9**.
/// Drives the per-kW bollo rate.
enum EuroClass { euro0, euro1, euro2, euro3, euro4, euro5, euro6 }

/// Result of a bollo (car tax) calculation. Amounts are euro per year.
class BolloResult {
  const BolloResult({required this.ordinary, required this.superbollo});

  /// Ordinary annual tax (tassa automobilistica).
  final double ordinary;

  /// Addizionale erariale ("superbollo") — only for cars over 185 kW.
  final double superbollo;

  double get total => ordinary + superbollo;
}

/// Computes the Italian car tax (bollo) **fully offline** from the data printed
/// on the libretto: power in kW (field **P.2**) and the Euro emission class
/// (field **V.9**).
///
/// Uses the **national base tariff**, which most regions adopt unchanged. A few
/// regions set their own rates and Sardegna / Friuli-Venezia Giulia are managed
/// separately, so for those the figure is an approximation — say so in the UI.
/// Electric and historic vehicles follow special/exempt regimes not modelled
/// here, so the caller should not offer this for them.
class BolloCalculator {
  const BolloCalculator();

  /// National €/kW rates per Euro class: `(up to 100 kW, portion above 100 kW)`.
  static const Map<EuroClass, (double, double)> nationalRates = {
    EuroClass.euro0: (3.00, 4.50),
    EuroClass.euro1: (2.90, 4.35),
    EuroClass.euro2: (2.80, 4.20),
    EuroClass.euro3: (2.70, 4.05),
    EuroClass.euro4: (2.58, 3.87),
    EuroClass.euro5: (2.58, 3.87),
    EuroClass.euro6: (2.58, 3.87),
  };

  /// [powerKw] from libretto P.2, [euroClass] from V.9. [vehicleAgeYears] is
  /// only used for the superbollo age discount; null is treated as new.
  BolloResult compute({
    required int powerKw,
    required EuroClass euroClass,
    int? vehicleAgeYears,
  }) {
    final (base, over) = nationalRates[euroClass]!;
    final ordinary = powerKw <= 100
        ? powerKw * base
        : 100 * base + (powerKw - 100) * over;
    return BolloResult(
      ordinary: ordinary,
      superbollo: _superbollo(powerKw, vehicleAgeYears),
    );
  }

  /// Addizionale erariale: €20 per kW above 185 kW, decreasing with the car's
  /// age (€12 at 6–10 yrs, €6 at 11–15, €3 at 16–20, then nil over 20).
  double _superbollo(int powerKw, int? ageYears) {
    if (powerKw <= 185) return 0;
    final age = ageYears ?? 0; // unknown age -> assume new (full rate)
    final perKw = switch (age) {
      < 6 => 20.0,
      < 11 => 12.0,
      < 16 => 6.0,
      <= 20 => 3.0,
      _ => 0.0,
    };
    return (powerKw - 185) * perKw;
  }
}

/// CV (cavalli) → kW, for when only horsepower is on hand (1 CV ≈ 0.7355 kW).
int cvToKw(int cv) => (cv * 0.7355).round();
