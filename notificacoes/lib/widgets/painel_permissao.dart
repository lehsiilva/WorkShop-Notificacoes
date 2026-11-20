import 'package:flutter/material.dart';
import '../../services/location_permission_service.dart';

class PermissionPanel extends StatefulWidget {
  const PermissionPanel({
    super.key,
    this.service,
    this.onChanged,
  });

  final LocationPermissionService? service;

  final ValueChanged<LocationAccess>? onChanged;

  @override
  State<PermissionPanel> createState() => _PermissionPanelState();
}

class _PermissionPanelState extends State<PermissionPanel>
    with WidgetsBindingObserver {
  late final LocationPermissionService _service =
      widget.service ?? LocationPermissionService();
  LocationAccess? _status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Quando o usuário volta das configurações, rechecamos o estado.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async => _update(await _service.check());

  Future<void> _ask() async => _update(await _service.request());

  void _update(LocationAccess s) {
    if (!mounted) return;
    setState(() => _status = s);
    widget.onChanged?.call(s);
  }

  @override
  Widget build(BuildContext context) {
    final s = _status;
    final (icon, color, text) = switch (s) {
      null => (Icons.hourglass_empty, Colors.grey, 'Verificando...'),
      LocationAccess.granted =>
        (Icons.check_circle, Colors.green, 'Permissão concedida'),
      LocationAccess.denied => (
          Icons.warning_amber,
          Colors.orange,
          'Permissão negada. Sem ela não dá para ler a posição.'
        ),
      LocationAccess.deniedForever => (
          Icons.block,
          Colors.red,
          'Negada definitivamente. Ative nas configurações do app.'
        ),
      LocationAccess.serviceDisabled => (
          Icons.location_off,
          Colors.red,
          'Localização desligada no aparelho.'
        ),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
            ]),
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              if (s == LocationAccess.denied || s == null)
                FilledButton(
                    onPressed: _ask, child: const Text('Pedir permissão')),
              if (s == LocationAccess.deniedForever)
                FilledButton(
                    onPressed: _service.openAppSettings,
                    child: const Text('Abrir configurações do app')),
              if (s == LocationAccess.serviceDisabled)
                FilledButton(
                    onPressed: _service.openLocationSettings,
                    child: const Text('Ativar localização')),
              OutlinedButton(
                  onPressed: _refresh, child: const Text('Verificar de novo')),
            ]),
          ],
        ),
      ),
    );
  }
}