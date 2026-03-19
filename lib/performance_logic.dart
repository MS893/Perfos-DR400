enum CalculationStatus { exact, interpolated, extrapolated, noData }

class PerformanceEntry {
  final double roll;
  final double distance;
  PerformanceEntry(this.roll, this.distance);
}

class PerformanceResult {
  final PerformanceEntry entry;
  final CalculationStatus status;
  PerformanceResult(this.entry, this.status);
}

// Classe de base pour tous les avions
abstract class Aircraft {
  final AircraftPerformance landing;
  Aircraft({required this.landing});

  // Méthode unifiée pour obtenir les perfs de décollage selon la piste
  PerformanceResult getTakeoffPerformance(double altitude, double temp, double mass, String runwayType);
  
  double calculateWindFactorTakeoff(double wind);
  double calculateWindFactorLanding(double wind);
  
  CalculationStatus getWindStatus(double wind) {
    return (wind >= 0 && wind <= 30) ? CalculationStatus.exact : CalculationStatus.extrapolated;
  }
}

// Type 1 : Un seul tableau + coefficient (ex: F-GYKX)
class AircraftWithCoeff extends Aircraft {
  final AircraftPerformance takeoffTable;
  final double grassFactor;

  AircraftWithCoeff({
    required this.takeoffTable,
    required super.landing,
    this.grassFactor = 1.15,
  });

  @override
  PerformanceResult getTakeoffPerformance(double altitude, double temp, double mass, String runwayType) {
    PerformanceResult res = takeoffTable.calculate(altitude, temp, mass);
    if (res.status == CalculationStatus.noData) return res;
    if (runwayType == 'Herbe') {
      return PerformanceResult(
        PerformanceEntry(res.entry.roll * grassFactor, res.entry.distance * grassFactor),
        res.status
      );
    }
    return res;
  }

  @override
  double calculateWindFactorTakeoff(double wind) {
    if (wind >= 0) {
      if (wind <= 10) return landing.interpolate(wind, 0, 1.0, 10, 0.85);
      if (wind <= 20) return landing.interpolate(wind, 10, 0.85, 20, 0.65);
      return landing.interpolate(wind, 20, 0.65, 30, 0.55);
    }
    return 1.0 + (wind.abs() / 2.0) * 0.10;
  }

  @override
  double calculateWindFactorLanding(double wind) {
    if (wind >= 0) {
      if (wind <= 10) return landing.interpolate(wind, 0, 1.0, 10, 0.78);
      if (wind <= 20) return landing.interpolate(wind, 10, 0.78, 20, 0.63);
      return landing.interpolate(wind, 20, 0.63, 30, 0.52);
    }
    return 1.0 + (wind.abs() / 2.0) * 0.10;
  }
}

// Type 2 : Deux tableaux distincts (ex: F-BVCY)
class AircraftWithMultiTables extends Aircraft {
  final AircraftPerformance takeoffDur;
  final AircraftPerformance takeoffHerbe;

  AircraftWithMultiTables({
    required this.takeoffDur,
    required this.takeoffHerbe,
    required super.landing,
  });

  @override
  PerformanceResult getTakeoffPerformance(double altitude, double temp, double mass, String runwayType) {
    if (runwayType == 'Herbe') {
      return takeoffHerbe.calculate(altitude, temp, mass);
    }
    return takeoffDur.calculate(altitude, temp, mass);
  }

  @override
  double calculateWindFactorTakeoff(double wind) {
    if (wind >= 0) {
      // Coefficients spécifiques F-BVCY : 0.78, 0.63, 0.52
      if (wind <= 10) return landing.interpolate(wind, 0, 1.0, 10, 0.78);
      if (wind <= 20) return landing.interpolate(wind, 10, 0.78, 20, 0.63);
      return landing.interpolate(wind, 20, 0.63, 30, 0.52);
    }
    return 1.0 + (wind.abs() / 2.0) * 0.10;
  }

  @override
  double calculateWindFactorLanding(double wind) {
    if (wind >= 0) {
      if (wind <= 10) return landing.interpolate(wind, 0, 1.0, 10, 0.78);
      if (wind <= 20) return landing.interpolate(wind, 10, 0.78, 20, 0.63);
      return landing.interpolate(wind, 20, 0.63, 30, 0.52);
    }
    return 1.0 + (wind.abs() / 2.0) * 0.10;
  }
}

class AircraftPerformance {
  final Map<double, Map<double, Map<double, PerformanceEntry>>> data;
  AircraftPerformance(this.data);

  bool get isEmpty => data.isEmpty;

  double interpolate(double x, double x0, double y0, double x1, double y1) {
    if (x1 == x0) return y0;
    return y0 + (x - x0) * (y1 - y0) / (x1 - x0);
  }

  MapEntry<List<double>, CalculationStatus> _getBoundsAndStatus(List<double> sortedValues, double target) {
    if (sortedValues.isEmpty) return const MapEntry([0, 0], CalculationStatus.noData);
    if (sortedValues.contains(target)) return MapEntry([target, target], CalculationStatus.exact);
    
    if (target < sortedValues.first || target > sortedValues.last) {
      if (sortedValues.length < 2) return MapEntry([sortedValues[0], sortedValues[0]], CalculationStatus.extrapolated);
      return target < sortedValues.first 
          ? MapEntry([sortedValues[0], sortedValues[1]], CalculationStatus.extrapolated)
          : MapEntry([sortedValues[sortedValues.length - 2], sortedValues[sortedValues.length - 1]], CalculationStatus.extrapolated);
    }
    int idx = sortedValues.indexWhere((v) => v >= target);
    return MapEntry([sortedValues[idx - 1], sortedValues[idx]], CalculationStatus.interpolated);
  }

  PerformanceResult calculate(double altitude, double temp, double mass) {
    if (isEmpty) return PerformanceResult(PerformanceEntry(0, 0), CalculationStatus.noData);

    double isaTemp = 15 - (2 * altitude / 1000);
    double deltaISA = temp - isaTemp;
    List<double> alts = data.keys.toList()..sort();
    var aRes = _getBoundsAndStatus(alts, altitude);
    
    var lowAltRes = _interpolateTemp(aRes.key[0], deltaISA, mass);
    var highAltRes = _interpolateTemp(aRes.key[1], deltaISA, mass);
    
    return PerformanceResult(
      PerformanceEntry(
        interpolate(altitude, aRes.key[0], lowAltRes.entry.roll, aRes.key[1], highAltRes.entry.roll),
        interpolate(altitude, aRes.key[0], lowAltRes.entry.distance, aRes.key[1], highAltRes.entry.distance),
      ),
      _getWorstStatus([aRes.value, lowAltRes.status, highAltRes.status])
    );
  }

  PerformanceResult _interpolateTemp(double alt, double deltaISA, double mass) {
    var tempMap = data[alt];
    if (tempMap == null) return PerformanceResult(PerformanceEntry(0, 0), CalculationStatus.noData);
    
    List<double> deltas = tempMap.keys.toList()..sort();
    var dRes = _getBoundsAndStatus(deltas, deltaISA);
    var lowTempRes = _interpolateMass(alt, dRes.key[0], mass);
    var highTempRes = _interpolateMass(alt, dRes.key[1], mass);
    
    return PerformanceResult(
      PerformanceEntry(
        interpolate(deltaISA, dRes.key[0], lowTempRes.entry.roll, dRes.key[1], highTempRes.entry.roll),
        interpolate(deltaISA, dRes.key[0], lowTempRes.entry.distance, dRes.key[1], highTempRes.entry.distance),
      ),
      _getWorstStatus([dRes.value, lowTempRes.status, highTempRes.status])
    );
  }

  PerformanceResult _interpolateMass(double alt, double deltaISA, double mass) {
    var massMap = data[alt]?[deltaISA];
    if (massMap == null) return PerformanceResult(PerformanceEntry(0, 0), CalculationStatus.noData);
    
    List<double> masses = massMap.keys.toList()..sort();
    var mRes = _getBoundsAndStatus(masses, mass);
    
    return PerformanceResult(
      PerformanceEntry(
        interpolate(mass, mRes.key[0], massMap[mRes.key[0]]!.roll, mRes.key[1], massMap[mRes.key[1]]!.roll),
        interpolate(mass, mRes.key[0], massMap[mRes.key[0]]!.distance, mRes.key[1], massMap[mRes.key[1]]!.distance),
      ),
      mRes.value
    );
  }

  CalculationStatus _getWorstStatus(List<CalculationStatus> statuses) {
    if (statuses.contains(CalculationStatus.noData)) return CalculationStatus.noData;
    if (statuses.contains(CalculationStatus.extrapolated)) return CalculationStatus.extrapolated;
    if (statuses.contains(CalculationStatus.interpolated)) return CalculationStatus.interpolated;
    return CalculationStatus.exact;
  }
}

// --- DONNÉES F-GYKX ---
final fGykx = AircraftWithCoeff(
  takeoffTable: AircraftPerformance({
    0.0: {
      -20.0: {700.0: PerformanceEntry(130, 285), 900.0: PerformanceEntry(225, 480)},
      0.0: {700.0: PerformanceEntry(145, 315), 900.0: PerformanceEntry(235, 535)},
      20.0: {700.0: PerformanceEntry(165, 345), 900.0: PerformanceEntry(285, 590)},
    },
    4000.0: {
      -20.0: {700.0: PerformanceEntry(175, 375), 900.0: PerformanceEntry(305, 645)},
      0.0: {700.0: PerformanceEntry(195, 415), 900.0: PerformanceEntry(345, 720)},
      20.0: {700.0: PerformanceEntry(220, 460), 900.0: PerformanceEntry(390, 800)},
    },
    8000.0: {
      -20.0: {700.0: PerformanceEntry(235, 500), 900.0: PerformanceEntry(425, 890)},
      0.0: {700.0: PerformanceEntry(265, 560), 900.0: PerformanceEntry(475, 1000)},
      20.0: {700.0: PerformanceEntry(300, 620), 900.0: PerformanceEntry(535, 1125)},
    },
  }),
  landing: AircraftPerformance({
    0.0: {
      -20.0: {700.0: PerformanceEntry(145, 365), 900.0: PerformanceEntry(185, 435)},
      0.0: {700.0: PerformanceEntry(155, 385), 900.0: PerformanceEntry(200, 460)},
      20.0: {700.0: PerformanceEntry(165, 400), 900.0: PerformanceEntry(210, 485)},
    },
    4000.0: {
      -20.0: {700.0: PerformanceEntry(160, 395), 900.0: PerformanceEntry(205, 475)},
      0.0: {700.0: PerformanceEntry(175, 420), 900.0: PerformanceEntry(225, 505)},
      20.0: {700.0: PerformanceEntry(185, 440), 900.0: PerformanceEntry(240, 535)},
    },
    8000.0: {
      -20.0: {700.0: PerformanceEntry(180, 430), 900.0: PerformanceEntry(235, 525)},
      0.0: {700.0: PerformanceEntry(195, 460), 900.0: PerformanceEntry(250, 555)},
      20.0: {700.0: PerformanceEntry(210, 485), 900.0: PerformanceEntry(270, 590)},
    },
  }),
);

// --- DONNÉES F-BVCY ---
final fBvcy = AircraftWithMultiTables(
  takeoffDur: AircraftPerformance({
    0.0: {
      -20.0: {700.0: PerformanceEntry(130, 285), 900.0: PerformanceEntry(225, 480)},
      0.0: {700.0: PerformanceEntry(145, 315), 900.0: PerformanceEntry(255, 535)},
      20.0: {700.0: PerformanceEntry(165, 345), 900.0: PerformanceEntry(285, 590)},
    },
    4000.0: {
      -20.0: {700.0: PerformanceEntry(175, 375), 900.0: PerformanceEntry(305, 645)},
      0.0: {700.0: PerformanceEntry(195, 415), 900.0: PerformanceEntry(345, 720)},
      20.0: {700.0: PerformanceEntry(220, 460), 900.0: PerformanceEntry(390, 800)},
    },
    8000.0: {
      -20.0: {700.0: PerformanceEntry(235, 500), 900.0: PerformanceEntry(425, 890)},
      0.0: {700.0: PerformanceEntry(265, 560), 900.0: PerformanceEntry(475, 1000)},
      20.0: {700.0: PerformanceEntry(300, 620), 900.0: PerformanceEntry(535, 1125)},
    },
  }),
  takeoffHerbe: AircraftPerformance({
    0.0: {
      -20.0: {700.0: PerformanceEntry(165, 320), 900.0: PerformanceEntry(315, 570)},
      0.0: {700.0: PerformanceEntry(185, 355), 900.0: PerformanceEntry(360, 640)},
      20.0: {700.0: PerformanceEntry(215, 395), 900.0: PerformanceEntry(410, 715)},
    },
    4000.0: {
      -20.0: {700.0: PerformanceEntry(230, 430), 900.0: PerformanceEntry(460, 800)},
      0.0: {700.0: PerformanceEntry(265, 485), 900.0: PerformanceEntry(530, 905)},
      20.0: {700.0: PerformanceEntry(300, 540), 900.0: PerformanceEntry(615, 1025)},
    },
    8000.0: {
      -20.0: {700.0: PerformanceEntry(330, 595), 900.0: PerformanceEntry(700, 1165)},
      0.0: {700.0: PerformanceEntry(380, 675), 900.0: PerformanceEntry(820, 1350)},
      20.0: {700.0: PerformanceEntry(440, 760), 900.0: PerformanceEntry(960, 1550)},
    },
  }),
  landing: AircraftPerformance({
    0.0: {
      -20.0: {700.0: PerformanceEntry(145, 365), 900.0: PerformanceEntry(185, 435)},
      0.0: {700.0: PerformanceEntry(155, 385), 900.0: PerformanceEntry(200, 460)},
      20.0: {700.0: PerformanceEntry(165, 400), 900.0: PerformanceEntry(210, 485)},
    },
    4000.0: {
      -20.0: {700.0: PerformanceEntry(160, 395), 900.0: PerformanceEntry(205, 475)},
      0.0: {700.0: PerformanceEntry(175, 420), 900.0: PerformanceEntry(225, 505)},
      20.0: {700.0: PerformanceEntry(185, 440), 900.0: PerformanceEntry(240, 535)},
    },
    8000.0: {
      -20.0: {700.0: PerformanceEntry(180, 430), 900.0: PerformanceEntry(235, 525)},
      0.0: {700.0: PerformanceEntry(195, 460), 900.0: PerformanceEntry(250, 555)},
      20.0: {700.0: PerformanceEntry(210, 485), 900.0: PerformanceEntry(270, 590)},
    },
  }),
);

// --- DONNÉES F-HAIX ---
final fHaix = AircraftWithCoeff(
  takeoffTable: AircraftPerformance({
    0.0: {
      -20.0: {900.0: PerformanceEntry(120, 250), 1100.0: PerformanceEntry(215, 445)},
      0.0: {900.0: PerformanceEntry(140, 290), 1100.0: PerformanceEntry(250, 515)},
      20.0: {900.0: PerformanceEntry(165, 340), 1100.0: PerformanceEntry(290, 600)},
    },
    2500.0: {
      -20.0: {900.0: PerformanceEntry(150, 310), 1100.0: PerformanceEntry(260, 540)},
      0.0: {900.0: PerformanceEntry(175, 360), 1100.0: PerformanceEntry(305, 635)},
      20.0: {900.0: PerformanceEntry(200, 415), 1100.0: PerformanceEntry(355, 735)},
    },
    5000.0: {
      -20.0: {900.0: PerformanceEntry(185, 385), 1100.0: PerformanceEntry(330, 680)},
      0.0: {900.0: PerformanceEntry(215, 450), 1100.0: PerformanceEntry(385, 795)},
      20.0: {900.0: PerformanceEntry(250, 520), 1100.0: PerformanceEntry(445, 925)},
    },
    8000.0: {
      -20.0: {900.0: PerformanceEntry(245, 505), 1100.0: PerformanceEntry(430, 890)},
      0.0: {900.0: PerformanceEntry(285, 590), 1100.0: PerformanceEntry(505, 1050)},
      20.0: {900.0: PerformanceEntry(335, 695), 1100.0: PerformanceEntry(590, 1225)},
    },
  }),
  landing: AircraftPerformance({
    0.0: {
      -20.0: {845.0: PerformanceEntry(190, 425), 1045.0: PerformanceEntry(230, 500)},
      0.0: {845.0: PerformanceEntry(200, 450), 1045.0: PerformanceEntry(250, 530)},
      20.0: {845.0: PerformanceEntry(215, 475), 1045.0: PerformanceEntry(270, 560)},
    },
    4000.0: {
      -20.0: {845.0: PerformanceEntry(210, 465), 1045.0: PerformanceEntry(260, 550)},
      0.0: {845.0: PerformanceEntry(230, 495), 1045.0: PerformanceEntry(280, 585)},
      20.0: {845.0: PerformanceEntry(240, 520), 1045.0: PerformanceEntry(300, 620)},
    },
    8000.0: {
      -20.0: {845.0: PerformanceEntry(240, 510), 1045.0: PerformanceEntry(295, 610)},
      0.0: {845.0: PerformanceEntry(260, 545), 1045.0: PerformanceEntry(320, 650)},
      20.0: {845.0: PerformanceEntry(275, 575), 1045.0: PerformanceEntry(340, 690)},
    },
  }),
);
