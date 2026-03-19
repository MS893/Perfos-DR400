import 'package:flutter_test/flutter_test.dart';
import 'package:perfos/main.dart';

void main() {
  testWidgets('Vérification du chargement de l\'application', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PerfosApp());

    // Vérifie que le titre est présent
    expect(find.text('Calcul des Performances'), findsOneWidget);
    
    // Vérifie qu'un des onglets est présent
    expect(find.text('F-GYKX'), findsOneWidget);
  });
}
