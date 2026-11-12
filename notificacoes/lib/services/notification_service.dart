import 'package:flutter_local_notifications/flutter_local_notifications.dart';


typedef NotificationTapCallback = void Function(String? payload);

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  /// Definido pela Pessoa 5 (navegação). A UI registra aqui o que fazer no toque.
  NotificationTapCallback? onTap;

  // ---------------------------------------------------------------
  // PESSOA 2: inicialização e permissões
  // ---------------------------------------------------------------

  /// Inicializa o plugin (Android + iOS). Chamar uma vez, no main().
  Future<void> init() async {
    throw UnimplementedError('Pessoa 2');
  }

  /// Pede permissão (POST_NOTIFICATIONS no Android 13+, iOS).
  /// Retorna true se concedida, false se negada.
  Future<bool> requestPermission() async {
    throw UnimplementedError('Pessoa 2');
  }

  // ---------------------------------------------------------------
  // PESSOA 3: canais e notificação imediata
  // ---------------------------------------------------------------

  /// Cria o(s) canal(is) Android (id, nome, importância, som).
  Future<void> createChannels() async {
    throw UnimplementedError('Pessoa 3');
  }

  /// Notificação imediata (requisito i).
  Future<void> showNow({required String title, required String body}) async {
    throw UnimplementedError('Pessoa 3');
  }

  // ---------------------------------------------------------------
  // PESSOA 4: agendamento
  // ---------------------------------------------------------------

  /// Agendada para daqui a 1 minuto, com fuso horário (requisito ii).
  Future<void> scheduleInOneMinute() async {
    throw UnimplementedError('Pessoa 4');
  }

  /// Recorrente: todo dia no horário [hour]:[minute].
  Future<void> scheduleDaily({required int hour, required int minute}) async {
    throw UnimplementedError('Pessoa 4');
  }

  Future<void> cancelAll() async {
    throw UnimplementedError('Pessoa 4');
  }

  // ---------------------------------------------------------------
  // PESSOA 5: payload e navegação
  // ---------------------------------------------------------------

  /// Notificação cujo toque leva a uma tela específica (requisito iii).
  /// O [payload] deve ser uma rota simples, ex.: '/detalhe'. Nada sensível.
  Future<void> showWithPayload({
    required String title,
    required String body,
    required String payload,
  }) async {
    throw UnimplementedError('Pessoa 5');
  }

  /// Se o app foi aberto POR uma notificação (estava fechado), retorna o payload.
  Future<String?> getLaunchPayload() async {
    throw UnimplementedError('Pessoa 5');
  }
}