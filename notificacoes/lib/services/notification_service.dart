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

  // --- Identificadores dos canais ---
  // O ID é o que o Android usa internamente para reconhecer o canal.
  // Depois que o canal é criado no aparelho, o ID NÃO deve mudar: se mudar,
  // o Android entende como um canal novo. Já o nome e a descrição são o que
  // o usuário vê nas configurações do app.
  static const String canalImportanteId = 'canal_importante';
  static const String canalImportanteNome = 'Notificações Importantes';
  static const String canalImportanteDescricao =
      'Avisos urgentes, com som e aviso na tela (heads-up)';

  // Segundo canal : mesma notificação, importância menor,
  // para mostrar na demo que o comportamento muda conforme o canal.
  static const String canalSilenciosoId = 'canal_silencioso';
  static const String canalSilenciosoNome = 'Notificações Discretas';
  static const String canalSilenciosoDescricao =
      'Avisos de baixa prioridade, sem som e sem aparecer sobre a tela';

  /// Registra os dois canais no Android assim que o app inicia.
  /// Chamar depois de initialize(). É opcional: o plugin.show() também cria
  /// o canal automaticamente na primeira vez, mas criar antes deixa os canais
  /// visíveis nas configurações do app desde o início.
  /// Em versões abaixo do Android 8 (API 26) canais não existem e este
  /// método simplesmente não faz nada.
  Future<void> createChannels() async {
    // Pega a implementação específica do Android do plugin (retorna null no iOS)
    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Canal com importância MÁXIMA: faz som e aparece como banner sobre a tela
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        canalImportanteId, // id (único, não muda)
        canalImportanteNome, // nome visível ao usuário
        description: canalImportanteDescricao,
        importance: Importance.max,
        playSound: true,
      ),
    );

    // Canal com importância BAIXA: aparece só na barra de notificações, sem som
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        canalSilenciosoId,
        canalSilenciosoNome,
        description: canalSilenciosoDescricao,
        importance: Importance.low,
        playSound: false,
      ),
    );
  }

  /// Cria o canal e dispara uma notificação instantaneamente
  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Detalhes do Android: aqui dizemos a QUAL canal a notificação pertence
    // e como ela deve se comportar. Se o canal ainda não existir, o plugin
    // cria com estas configurações.
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      canalImportanteId, // id do canal
      canalImportanteNome, // nome do canal (visto nas configurações)
      channelDescription: canalImportanteDescricao,
      importance: Importance.max, // nível do canal: som + banner na tela
      priority: Priority.high, // prioridade da notificação (Android < 8)
      playSound: true, // toca o som padrão do sistema
      ticker: 'Nova notificação', // texto lido por leitores de tela
    );

    // Detalhes do iOS: no iOS não existem canais, então só definimos
    // se a notificação mostra alerta, badge e som.
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Junta as configurações das duas plataformas em um único objeto
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Dispara a notificação AGORA. O id identifica a notificação: usar o mesmo
    // id de novo substitui a anterior em vez de empilhar outra.
    // O payload (se houver) é repassado para a parte da Pessoa 5.
    await plugin.show(id, title, body, details, payload: payload);
  }

  /// Notificação imediata no canal de baixa importância.
  /// Serve para comparar na demo com showImmediateNotification: mesmo texto,
  /// mas sem som e sem banner, só aparece na barra de notificações.
  Future<void> showLowImportanceNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      canalSilenciosoId,
      canalSilenciosoNome,
      channelDescription: canalSilenciosoDescricao,
      importance: Importance.low, // sem som, sem heads-up
      priority: Priority.low,
      playSound: false,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false, // sem som, equivalente ao canal discreto
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await plugin.show(id, title, body, details, payload: payload);
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