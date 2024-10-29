import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:somativa_flutter/home_page.dart'; // Substitua pelo caminho correto do seu arquivo home.dart

// Crie mocks para as dependências
class MockGeolocator extends Mock implements GeolocatorPlatform {}

void main() {
  // Inicialize os mocks
  final mockGeolocator = MockGeolocator();

  setUp(() {
    // Configure o comportamento dos mocks, se necessário
  });

  testWidgets('HomePage displays location message', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    expect(find.text('Obtendo localização...'), findsOneWidget);
  });

  testWidgets('HomePage displays closest environment', (WidgetTester tester) async {
    // Simule uma atualização de localização
    when(mockGeolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high))
        .thenAnswer((_) async => Position(
            latitude: 0.0,
            longitude: 0.0,
            timestamp: DateTime.now(),
            accuracy: 1.0,
            altitude: 1.0,
            heading: 1.0,
            speed: 1.0,
            speedAccuracy: 1.0,
            altitudeAccuracy: null,
            headingAccuracy: null));

    // Recrie a HomePage com os mocks configurados
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Aguarde a conclusão da Future
    await tester.pump();

    // Verifique se o ambiente mais próximo é exibido corretamente
    expect(find.text('Sem ambientes próximos'), findsOneWidget);
  });
}
