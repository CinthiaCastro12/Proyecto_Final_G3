
import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_bancario/main.dart'; // Asegúrate de que la ruta sea correcta

void main() {
  testWidgets('Prueba de inicio de la aplicación', (WidgetTester tester) async {
    // Llama a la clase principal SistemaBancarioApp
    await tester.pumpWidget(const SistemaBancarioApp());

    // Verifica si el título de inicio de sesión aparece correctamente
    expect(find.text('Inicio de Sesión'), findsOneWidget);
    expect(find.text('Credenciales incorrectas'), findsNothing);
  });
}

