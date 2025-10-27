// Testes básicos do ClubePharma
import 'package:flutter_test/flutter_test.dart';

import 'package:clube_pharma_frontend/main.dart';

void main() {
  testWidgets('App inicia na tela de boas-vindas', (WidgetTester tester) async {
    // Constrói o app
    await tester.pumpWidget(const ClubePharmaApp());

    // Verifica se o texto "ClubePharma" aparece na tela
    expect(find.text('CLUBE DE BENEFÍCIOS'), findsOneWidget);

    // Verifica se o botão "Acessar Plataforma" existe
    expect(find.text('Acessar Plataforma'), findsOneWidget);
  });
}
