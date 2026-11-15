import 'package:flutter/material.dart';
import '../services/notification_service.dart';

/// Tela única do app (Pessoa 6): um bloco por parte do workshop,
/// na mesma ordem da apresentação.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _aviso(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    final s = NotificationService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Notificações Locais')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Secao(
            titulo: '1. Permissão',
            subtitulo: 'POST_NOTIFICATIONS (Android 13+) e iOS',
            botoes: [
              _Botao(
                texto: 'Pedir permissão',
                icone: Icons.verified_user,
                onPressed: () async {
                  final ok = await s.requestPermissions(context);
                  if (ok && context.mounted) {
                    _aviso(context, 'Permissão concedida');
                  }
                },
              ),
            ],
          ),
          _Secao(
            titulo: '2. Canais e notificação imediata',
            subtitulo: 'Mesmo texto, importâncias diferentes',
            botoes: [
              _Botao(
                texto: 'Imediata (importante)',
                icone: Icons.notifications_active,
                onPressed: () => s.showImmediateNotification(
                  id: 1,
                  title: 'Olá',
                  body: 'Notificação imediata (canal importante)',
                ),
              ),
              _Botao(
                texto: 'Imediata (discreta)',
                icone: Icons.notifications_none,
                onPressed: () async {
                  await s.showLowImportanceNotification(
                    id: 2,
                    title: 'Olá',
                    body: 'Notificação discreta (canal silencioso)',
                  );
                  if (context.mounted) {
                    _aviso(
                      context,
                      'Enviada sem som e sem banner: puxe a barra de notificações',
                    );
                  }
                },
              ),
            ],
          ),
          _Secao(
            titulo: '3. Agendamento',
            subtitulo: 'Fuso horário, recorrência e Doze mode',
            botoes: [
              _Botao(
                texto: 'Agendar para 1 minuto',
                icone: Icons.timer,
                onPressed: () async {
                  final quando = DateTime.now().add(const Duration(minutes: 1));
                  await s.scheduleNotification(
                    id: 3,
                    title: 'Agendada',
                    body: 'Chegou, 1 minuto depois!',
                    scheduledDate: quando,
                  );
                  if (context.mounted) {
                    _aviso(
                      context,
                      'Agendada para ${TimeOfDay.fromDateTime(quando).format(context)}',
                    );
                  }
                },
              ),
              _Botao(
                texto: 'Agendar diária (escolher horário)',
                icone: Icons.repeat,
                onPressed: () async {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    helpText: 'Horário da notificação diária',
                  );
                  if (hora == null) return;
                  await s.showPeriodicNotification(
                    id: 4,
                    title: 'Diária',
                    body: 'Notificação recorrente',
                    hour: hora.hour,
                    minute: hora.minute,
                  );
                  if (context.mounted) {
                    _aviso(
                      context,
                      'Diária agendada para ${hora.format(context)}, todo dia',
                    );
                  }
                },
              ),
              _Botao(
                texto: 'Cancelar agendadas',
                icone: Icons.cancel_outlined,
                onPressed: () async {
                  await s.cancelNotification(3);
                  await s.cancelNotification(4);
                  if (context.mounted) {
                    _aviso(context, 'Agendadas canceladas');
                  }
                },
              ),
            ],
          ),
          _Secao(
            titulo: '4. Payload e navegação',
            subtitulo: 'O toque abre a tela de detalhe',
            botoes: [
              _Botao(
                texto: 'Notificação com payload',
                icone: Icons.open_in_new,
                onPressed: () => s.showWithPayload(
                  title: 'Toque aqui',
                  body: 'Abre a tela de detalhe',
                  payload: '/detalhe',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  const _Secao({
    required this.titulo,
    required this.subtitulo,
    required this.botoes,
  });

  final String titulo;
  final String subtitulo;
  final List<Widget> botoes;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: tema.titleMedium),
            const SizedBox(height: 4),
            Text(subtitulo, style: tema.bodySmall),
            const SizedBox(height: 12),
            ...botoes.expand((b) => [b, const SizedBox(height: 8)]),
          ],
        ),
      ),
    );
  }
}

class _Botao extends StatelessWidget {
  const _Botao({
    required this.texto,
    required this.icone,
    required this.onPressed,
  });

  final String texto;
  final IconData icone;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: Icon(icone),
        label: Text(texto),
      ),
    );
  }
}