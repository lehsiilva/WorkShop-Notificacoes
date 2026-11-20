import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'services/location_permition_service.dart';
=======
import 'screens/detail_screen.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
>>>>>>> e41202178e9fcf9e6cdcada73a739d28aeaf8b0d

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pessoa 2: inicializa o plugin.
  await NotificationService.instance.initialize();
  // Pessoa 3: registra os canais Android (depois do initialize).
  await NotificationService.instance.createChannels();

  runApp(const WorkshopApp());

  // Pessoa 5: caso o app estivesse FECHADO e foi aberto pela notificação.
  // addPostFrameCallback espera o primeiro frame, quando o Navigator já existe.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final payload = await NotificationService.instance.getLaunchPayload();
    // Valida a rota com a mesma regra usada no toque da notificação.
    if (payload != null && NotificationService.rotaPermitida(payload)) {
      navigatorKey.currentState?.pushNamed(payload);
    }
  });
}

class WorkshopApp extends StatelessWidget {
  const WorkshopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Notificações Locais',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      routes: {
        '/': (_) => const HomeScreen(), // Pessoa 6
        '/detalhe': (_) => const DetailScreen(), // Pessoa 5
      },
    );
  }
}