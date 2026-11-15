import 'package:flutter/material.dart';

/// Tela aberta quando a notificação com payload é tocada.
/// O payload da notificação é o nome da rota '/detalhe'.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_active, size: 72),
            const SizedBox(height: 16),
            const Text(
              'Tela aberta pela notificação',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              // Volta para a tela anterior (o Navigator guarda a pilha de telas).
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
