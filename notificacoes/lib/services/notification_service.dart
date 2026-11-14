import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  // Instância global do plugin
  final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  // =========================================================================
  // PESSOA 2: Inicialização e Permissões (SUA PARTE)
  // =========================================================================

  /// Configura as definições iniciais para Android e iOS
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
  }

  /// Pede permissão de POST_NOTIFICATIONS (Android 13+) e permissões no iOS
  Future<bool> requestPermissions(BuildContext context) async {
    bool isGranted = false;

    if (Theme.of(context).platform == TargetPlatform.android) {
      final status = await Permission.notification.request();
      isGranted = status.isGranted;
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      final bool? result = await plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      isGranted = result ?? false;
    }

    // Tratar a recusa: Se o usuário negar, mostramos um diálogo pedindo para abrir as configurações
    if (!isGranted && context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permissão Necessária'),
          content: const Text(
              'As notificações estão desativadas. Precisamos dessa permissão para o aplicativo funcionar corretamente.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text('Abrir Configurações'),
            ),
          ],
        ),
      );
    }

    return isGranted;
  }

  // =========================================================================
  // PESSOA 3: Canais e Notificação Imediata
  // =========================================================================

  /// Cria o canal e dispara uma notificação instantaneamente
  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // TODO: Configurar AndroidNotificationDetails (id, nome, importância) 
    // e chamar plugin.show()
  }

  // =========================================================================
  // PESSOA 4: Agendamento
  // =========================================================================

  /// Agenda uma notificação (ex: para daqui a 1 minuto) com timezone
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // TODO: Implementar plugin.zonedSchedule com fuso horário
  }

  /// Configura uma notificação que se repete periodicamente
  Future<void> showPeriodicNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // TODO: Implementar plugin.periodicallyShow ou matchDateTimeComponents
  }

  /// Cancela uma notificação específica pelo ID
  Future<void> cancelNotification(int id) async {
    // TODO: Implementar plugin.cancel(id)
  }

  // =========================================================================
  // PESSOA 5: Payload e Navegação
  // =========================================================================

  /// Callback acionado quando o usuário toca na notificação
  @pragma('vm:entry-point')
  static void onNotificationTap(NotificationResponse notificationResponse) {
    // TODO: Lógica de navegação baseada no notificationResponse.payload
    // (Pode exigir o uso de uma GlobalKey<NavigatorState> definida no main)
  }
}
