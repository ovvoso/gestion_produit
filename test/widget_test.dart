import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_produit/main.dart';

void main() {
  testWidgets('Product list test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Vérifier que le titre est présent
    expect(find.text('Liste des Produits'), findsOneWidget);

    // Vérifier que le bouton d'ajout est présent
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
