import 'package:flutter/material.dart';
import 'services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pessoa 2: descomentar quando init() estiver pronto.
  // await NotificationService.instance.init();
  runApp(const WorkshopApp());
}

class WorkshopApp extends StatelessWidget {
  const WorkshopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Notificações Locais',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      routes: {
        '/': (_) => const HomeScreen(),
        '/detalhe': (_) => const DetailScreen(), // Pessoa 5
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = NotificationService.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações Locais')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton(
            onPressed: () => s.requestPermission(), // Pessoa 2
            child: const Text('Pedir permissão'),
          ),
          FilledButton(
            onPressed: () => s.showNow(title: 'Olá', body: 'Imediata'), // Pessoa 3
            child: const Text('Notificação imediata'),
          ),
          FilledButton(
            onPressed: () => s.scheduleInOneMinute(), // Pessoa 4
            child: const Text('Agendar para 1 minuto'),
          ),
          FilledButton(
            onPressed: () => s.showWithPayload(
              title: 'Toque aqui',
              body: 'Abre a tela de detalhe',
              payload: '/detalhe',
            ), // Pessoa 5
            child: const Text('Notificação com payload'),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Tela aberta pela notificação')),
    );
  }
}