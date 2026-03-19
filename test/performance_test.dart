import 'package:flutter_test/flutter_test.dart';
import 'package:perfos/performance_logic.dart';

void main() {
  group('Tests F-GYKX (Type : Coefficient Herbe)', () {
    test('Décollage - Valeur exacte (0ft, ISA, 900kg)', () {
      final res = fGykx.getTakeoffPerformance(0, 15, 900, 'Dur');
      expect(res.entry.roll, 235);
      expect(res.entry.distance, 535);
      expect(res.status, CalculationStatus.exact);
    });

    test('Décollage - Interpolation Masse (800kg)', () {
      final res = fGykx.getTakeoffPerformance(0, 15, 800, 'Dur');
      expect(res.entry.roll, 190); // (145 + 235) / 2
      expect(res.status, CalculationStatus.interpolated);
    });

    test('Décollage - Correction Herbe (+15%)', () {
      final res = fGykx.getTakeoffPerformance(0, 15, 900, 'Herbe');
      expect(res.entry.roll, 235 * 1.15);
      expect(res.entry.distance, 535 * 1.15);
    });

    test('Vent - Correction Face 10kt (x0.85)', () {
      final factor = fGykx.calculateWindFactorTakeoff(10);
      expect(factor, 0.85);
    });

    test('Vent - Correction Arrière 2kt (+10%)', () {
      final factor = fGykx.calculateWindFactorTakeoff(-2);
      expect(factor, 1.10);
    });
  });

  group('Tests F-BVCY (Type : Multi-tableaux Herbe/Dur)', () {
    test('Décollage Dur - Valeur exacte', () {
      final res = fBvcy.getTakeoffPerformance(0, 15, 900, 'Dur');
      expect(res.entry.roll, 255);
    });

    test('Décollage Herbe - Valeur du tableau spécifique', () {
      final res = fBvcy.getTakeoffPerformance(0, 15, 900, 'Herbe');
      // Pour F-BVCY à 0ft/ISA/900kg, le tableau Herbe donne 360m (pas 255 * 1.15)
      expect(res.entry.roll, 360);
    });

    test('Vent - Coefficients spécifiques (Face 10kt = x0.78)', () {
      final factor = fBvcy.calculateWindFactorTakeoff(10);
      expect(factor, 0.78);
    });
  });

  group('Tests F-HAIX (Type : Nouvelles Masses)', () {
    test('Décollage - Masse 1100kg (Valeur exacte)', () {
      final res = fHaix.getTakeoffPerformance(0, 15, 1100, 'Dur');
      expect(res.entry.roll, 250);
      expect(res.entry.distance, 515);
    });

    test('Atterrissage - Masse 1045kg (Valeur exacte)', () {
      final res = fHaix.landing.calculate(0, 15, 1045);
      expect(res.entry.roll, 250);
      expect(res.entry.distance, 530);
    });

    test('Extrapolation - Altitude 10000ft (Hors tableau)', () {
      final res = fHaix.getTakeoffPerformance(10000, 15, 1100, 'Dur');
      expect(res.status, CalculationStatus.extrapolated);
      expect(res.entry.roll, greaterThan(505)); // Doit être > à la valeur de 8000ft
    });
  });

  group('Tests Global Logic', () {
    test('Atmosphère ISA - Calcul Delta ISA', () {
      // ISA à 4000ft est 7°C. Température 10°C => Delta ISA +3
      const alt = 4000.0;
      const temp = 10.0;
      double isaTemp = 15 - (2 * alt / 1000);
      double deltaISA = temp - isaTemp;
      expect(deltaISA, 3.0);
    });
  });
}
