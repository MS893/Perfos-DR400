import 'package:flutter/material.dart';
import 'performance_logic.dart';
import 'checklist_data.dart';

void main() {
  runApp(const PerfosApp());
}

class PerfosApp extends StatelessWidget {
  const PerfosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfos Décollage & Atterrissage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PerformanceCalculator(),
    );
  }
}

class PerformanceCalculator extends StatefulWidget {
  const PerformanceCalculator({super.key});

  @override
  State<PerformanceCalculator> createState() => _PerformanceCalculatorState();
}

class _PerformanceCalculatorState extends State<PerformanceCalculator> {
  final TextEditingController _altitudeController = TextEditingController(text: '0');
  final TextEditingController _tempController = TextEditingController(text: '15');
  final TextEditingController _massController = TextEditingController(text: '900');
  final TextEditingController _windController = TextEditingController(text: '0');
  
  String _runwayType = 'Dur';
  String _surfaceState = 'Sèche';

  @override
  void initState() {
    super.initState();
    _altitudeController.addListener(() => setState(() {}));
    _tempController.addListener(() => setState(() {}));
    _massController.addListener(() => setState(() {}));
    _windController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    double? altitude = double.tryParse(_altitudeController.text);
    double? temp = double.tryParse(_tempController.text);
    double? mass = double.tryParse(_massController.text);
    double? wind = double.tryParse(_windController.text);

    String deltaISAText = "--";
    if (altitude != null && temp != null) {
      double isaTemp = 15 - (2 * altitude / 1000);
      double deltaISA = temp - isaTemp;
      String sign = deltaISA >= 0 ? "+" : "";
      deltaISAText = "ISA $sign${deltaISA.toStringAsFixed(1)}°C";
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calcul des Performances'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.playlist_add_check_rounded, size: 28),
                tooltip: 'Check-list',
                onPressed: () {
                  final tabIndex = DefaultTabController.of(context).index;
                  final planeNames = ['F-GYKX', 'F-BVCY', 'F-HAIX'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChecklistPage(planeName: planeNames[tabIndex]),
                    ),
                  );
                },
              ),
            ),
          ],
          bottom: const TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'F-GYKX'),
              Tab(text: 'F-BVCY'),
              Tab(text: 'F-HAIX'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _altitudeController,
                              decoration: const InputDecoration(labelText: 'Altitude (ft)', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _tempController,
                              decoration: const InputDecoration(labelText: 'Température (°C)', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Atmosphère : $deltaISAText',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _massController,
                              decoration: const InputDecoration(labelText: 'Masse (kg)', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _windController,
                              decoration: const InputDecoration(labelText: 'Vent Face(+) / Arr(-) (kt)', border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Piste :'),
                          DropdownButton<String>(
                            value: _runwayType,
                            items: ['Dur', 'Herbe'].map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (val) => setState(() => _runwayType = val!),
                          ),
                          const Text('État :'),
                          DropdownButton<String>(
                            value: _surfaceState,
                            items: ['Sèche', 'Mouillée'].map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (val) => setState(() => _surfaceState = val!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PlaneResultView(
                    planeName: 'F-GYKX',
                    aircraft: fGykx,
                    altitude: altitude,
                    temp: temp,
                    mass: mass,
                    wind: wind,
                    runwayType: _runwayType,
                    surfaceState: _surfaceState,
                  ),
                  PlaneResultView(
                    planeName: 'F-BVCY',
                    aircraft: fBvcy,
                    altitude: altitude,
                    temp: temp,
                    mass: mass,
                    wind: wind,
                    runwayType: _runwayType,
                    surfaceState: _surfaceState,
                  ),
                  PlaneResultView(
                    planeName: 'F-HAIX',
                    aircraft: fHaix,
                    altitude: altitude,
                    temp: temp,
                    mass: mass,
                    wind: wind,
                    runwayType: _runwayType,
                    surfaceState: _surfaceState,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChecklistPage extends StatefulWidget {
  final String planeName;
  const ChecklistPage({super.key, required this.planeName});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final Map<int, List<bool>> _checkedItems = {};
  int _expandedIndex = 0; 
  final ScrollController _scrollController = ScrollController();

  bool _isSectionComplete(int sectionIdx, List<ChecklistItem> items) {
    final checkedList = _checkedItems[sectionIdx];
    if (checkedList == null) return false;
    
    // Une section est complète si TOUS les items cochables sont cochés
    for (int i = 0; i < items.length; i++) {
      if (items[i].isCheckable && !checkedList[i]) {
        return false;
      }
    }
    return true;
  }

  void _scrollToIndex(int index) {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          index * 56.0, 
          duration: const Duration(milliseconds: 300), 
          curve: Curves.easeInOut
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final checklist = aircraftChecklists[widget.planeName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Check-list ${widget.planeName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {
              _checkedItems.clear();
              _expandedIndex = 0;
              _scrollToIndex(0);
            }),
            tooltip: 'Réinitialiser',
          )
        ],
      ),
      body: checklist.isEmpty
          ? const Center(child: Text('Aucune check-list disponible pour cet avion.'))
          : ListView.builder(
              controller: _scrollController,
              itemCount: checklist.length,
              itemBuilder: (context, sectionIdx) {
                final section = checklist[sectionIdx];
                final isComplete = _isSectionComplete(sectionIdx, section.items);
                final isOpen = _expandedIndex == sectionIdx;

                Color titleColor = Colors.blue;
                if (isOpen) {
                  titleColor = Colors.purple;
                } else if (isComplete) {
                  titleColor = Colors.green;
                }

                return Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    key: UniqueKey(),
                    initiallyExpanded: isOpen,
                    onExpansionChanged: (open) {
                      if (open) {
                        setState(() => _expandedIndex = sectionIdx);
                        _scrollToIndex(sectionIdx);
                      } else if (_expandedIndex == sectionIdx) {
                        setState(() => _expandedIndex = -1);
                      }
                    },
                    title: Text(
                      section.title,
                      style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
                    ),
                    children: List.generate(section.items.length, (itemIdx) {
                      final item = section.items[itemIdx];
                      _checkedItems[sectionIdx] ??= List.filled(section.items.length, false);
                      
                      if (!item.isCheckable) {
                        return ListTile(
                          title: Text(item.action, style: const TextStyle(fontSize: 14)),
                          subtitle: Text(item.status, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                          dense: true,
                        );
                      }

                      return CheckboxListTile(
                        value: _checkedItems[sectionIdx]![itemIdx],
                        onChanged: (val) {
                          setState(() {
                            _checkedItems[sectionIdx]![itemIdx] = val!;
                            
                            if (_isSectionComplete(sectionIdx, section.items)) {
                              if (_expandedIndex < checklist.length - 1) {
                                _expandedIndex++;
                                _scrollToIndex(_expandedIndex);
                              } else {
                                _expandedIndex = -1;
                              }
                            }
                          });
                        },
                        title: Text(item.action),
                        subtitle: Text(item.status, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }),
                  ),
                );
              },
            ),
    );
  }
}

class PlaneResultView extends StatelessWidget {
  final String planeName;
  final Aircraft? aircraft;
  final double? altitude;
  final double? temp;
  final double? mass;
  final double? wind;
  final String runwayType;
  final String surfaceState;

  const PlaneResultView({
    super.key,
    required this.planeName,
    this.aircraft,
    this.altitude,
    this.temp,
    this.mass,
    this.wind,
    required this.runwayType,
    required this.surfaceState,
  });

  @override
  Widget build(BuildContext context) {
    if (aircraft == null || altitude == null || temp == null || mass == null || wind == null) {
      return const Center(child: Text('Données manquantes ou invalides.'));
    }

    // --- CALCULS DÉCOLLAGE ---
    PerformanceResult takeoffRes = aircraft!.getTakeoffPerformance(altitude!, temp!, mass!, runwayType);
    double windFactorTakeoff = aircraft!.calculateWindFactorTakeoff(wind!);
    
    double toRoll = takeoffRes.entry.roll * windFactorTakeoff;
    double toDist = takeoffRes.entry.distance * windFactorTakeoff;

    // --- CALCULS ATTERRISSAGE ---
    PerformanceResult landingRes = aircraft!.landing.calculate(altitude!, temp!, mass!);
    double windFactorLanding = aircraft!.calculateWindFactorLanding(wind!);
    
    double ldRoll = landingRes.entry.roll * windFactorLanding;
    double ldDist = landingRes.entry.distance * windFactorLanding;

    // Correction Mouillée (+10%)
    if (surfaceState == 'Mouillée') {
      toRoll *= 1.10;
      toDist *= 1.10;
      ldRoll *= 1.10;
      ldDist *= 1.10;
    }

    // Distance de sécurité (+15%)
    double toDistSafety = toDist * 1.15;
    double ldDistSafety = ldDist * 1.15;

    CalculationStatus finalStatus = _getWorstStatus([
      takeoffRes.status, 
      landingRes.status, 
      aircraft!.getWindStatus(wind!)
    ]);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        child: Column(
          children: [
            if (finalStatus == CalculationStatus.noData)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Données non disponibles pour cet avion.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              )
            else ...[
              if (finalStatus != CalculationStatus.exact) 
                _buildStatusWarning(finalStatus) 
              else 
                const SizedBox(height: 16),
              
              _buildSectionTitle('DÉCOLLAGE (Passage 15m)'),
              _buildResultRow(context, 'Roulement', toRoll, Colors.blue.shade50),
              _buildDualResultRow(context, 'Distance Totale', toDistSafety, toDist, Colors.blue.shade100),
              
              const SizedBox(height: 12),
              _buildSectionTitle('ATTERRISSAGE (Passage 15m)'),
              _buildResultRow(context, 'Roulement', ldRoll, Colors.green.shade50),
              _buildDualResultRow(context, 'Distance Totale', ldDistSafety, ldDist, Colors.green.shade100),
              
              const SizedBox(height: 20),
              _buildInfoCard(windFactorTakeoff, windFactorLanding),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
    );
  }

  CalculationStatus _getWorstStatus(List<CalculationStatus> statuses) {
    if (statuses.contains(CalculationStatus.noData)) return CalculationStatus.noData;
    if (statuses.contains(CalculationStatus.extrapolated)) return CalculationStatus.extrapolated;
    if (statuses.contains(CalculationStatus.interpolated)) return CalculationStatus.interpolated;
    return CalculationStatus.exact;
  }

  Widget _buildStatusWarning(CalculationStatus status) {
    bool isExtrapolated = status == CalculationStatus.extrapolated;
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 22),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isExtrapolated ? Colors.red.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isExtrapolated ? Colors.red : Colors.orange),
      ),
      child: Row(
        children: [
          Icon(isExtrapolated ? Icons.warning_amber_rounded : Icons.info_outline, color: isExtrapolated ? Colors.red : Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(isExtrapolated ? 'EXTRAPOLATION : résultats calculés et imprécis.' : 'Note : Valeurs interpolées.', style: TextStyle(color: isExtrapolated ? Colors.red.shade900 : Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, String label, double value, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.black12)),
            child: Text('${value.toStringAsFixed(0)} m', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildDualResultRow(BuildContext context, String label, double safetyValue, double tableValue, Color tableBgColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.orange.shade200)),
            child: Center(child: Text('${safetyValue.toStringAsFixed(0)} m*', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange))),
          ),
          const SizedBox(width: 8),
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(color: tableBgColor, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.black12)),
            child: Center(child: Text('${tableValue.toStringAsFixed(0)} m', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54))),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(double wfTO, double wfLD) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text('Notes et Corrections :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            const Text('(*) Distance majorée de 15% (Pilote niveau standard)', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.deepOrange)),
            const SizedBox(height: 8),
            Text('• Vent TO: x${wfTO.toStringAsFixed(2)} | LD: x${wfLD.toStringAsFixed(2)}', style: const TextStyle(fontSize: 11)),
            if (runwayType == 'Herbe') const Text('• Herbe : Coefficient ou tableau spécifique appliqué', style: TextStyle(fontSize: 11)),
            if (surfaceState == 'Mouillée') const Text('• Piste Mouillée : +10% (Valeur estimée, non constructeur)', style: TextStyle(fontSize: 11, color: Colors.blueGrey, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
