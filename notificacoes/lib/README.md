# Notificações Locais em Flutter

Projeto do Workshop Técnico (PUC Minas, Laboratório de Desenvolvimento para Dispositivos Móveis).
Demonstra notificações locais com o pacote `flutter_local_notifications`:
imediata, agendada (1 minuto e recorrente) e com payload que abre uma tela.

## Como executar

Pré-requisitos: Flutter SDK instalado (`flutter doctor` sem erros) e um
emulador Android ou dispositivo físico.

```bash
git clone <URL-DO-REPOSITORIO>
cd <PASTA-DO-REPOSITORIO>
flutter pub get
flutter run
```

Se começar do zero, crie o projeto e adicione as dependências:

```bash
flutter create notificacoes_workshop
cd notificacoes_workshop
flutter pub add flutter_local_notifications timezone flutter_timezone
```

Depois copie a pasta `lib/` deste repositório para o projeto.

## Estrutura

```
lib/
  main.dart                          # app de tela única com os botões
  services/notification_service.dart # toda a lógica de notificações
```

## Quem faz o quê

| Parte | Responsável | Métodos em `NotificationService` |
|---|---|---|
| Estrutura, README, local vs. push | [Letícia Beatriz da Silva Lopes](https://github.com/lehsiilva) | `NotificationService`, `main.dart` |
| Inicialização e permissões | Pessoa 2 | `init`, `requestPermission` |
| Canais e imediata | Pessoa 3 | `createChannels`, `showNow` |
| Agendamento | Pessoa 4 | `scheduleInOneMinute`, `scheduleDaily`, `cancelAll` |
| Payload e navegação | Pessoa 5 | `showWithPayload`, `getLaunchPayload`, `onTap` |
| Integração, UI e demo | Pessoa 6 | `main.dart`, testes |

## Fluxo de trabalho no Git

- Uma branch por pessoa: `pessoa2-permissoes`, `pessoa3-canais`, etc.
- Cada um edita **apenas os seus métodos** no `notification_service.dart`.
- Merge na `main` por Pessoa 1 ou 6, via Pull Request.

## Permissões Android (Pessoa 2 e 4 completam)

Em `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<!-- Pessoa 4, se usar alarme exato: -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

## Roteiro da demonstração

1. Pedir permissão.
2. Notificação imediata.
3. Agendar para 1 minuto (deixar rodando durante a explicação do Doze mode).
4. Notificação com payload: tocar e abrir a tela de detalhe.

## Referências

- https://pub.dev/packages/flutter_local_notifications
- https://developer.android.com/develop/ui/views/notifications