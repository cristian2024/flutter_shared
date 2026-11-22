import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'ambient_urgency.dart';

/// Cómo se presenta un aviso.
enum AmbientAlertPresentation {
  /// Ocupa toda la pantalla (alarma sonando, temporizador terminado). Si
  /// coinciden varios, se ponen en cola por prioridad.
  fullScreen,

  /// Franja sobre la pantalla principal. Solo cabe uno a la vez.
  banner,
}

/// Qué hace un aviso durante las horas de silencio (p. ej. de noche).
enum AmbientQuietHoursPolicy {
  /// Se muestra igual.
  show,

  /// Se oculta hasta que terminen las horas de silencio.
  defer,
}

/// Botón de un aviso. Al pulsarlo, el host llama a
/// [AmbientAlertSource.onAction] con su [id].
class AmbientAlertAction extends Equatable {
  final String id;

  /// Texto del botón, ya traducido.
  final String label;

  /// Acción principal (la que el host destaca).
  final bool isPrimary;

  const AmbientAlertAction({required this.id, required this.label, this.isPrimary = false});

  @override
  List<Object?> get props => <Object?>[id, label, isPrimary];

  @override
  bool get stringify => true;
}

/// Aviso que un plugin publica para que el host lo muestre a pantalla
/// completa o como banner (p. ej. alarma sonando, batería crítica). Son
/// datos: el host lo dibuja con su sistema de diseño. Los textos llegan ya
/// traducidos.
class AmbientAlert extends Equatable {
  /// Identificador estable dentro de [sourceId].
  final String id;

  /// `id` del plugin que lo publica.
  final String sourceId;

  /// Menor número, más prioridad: si coinciden dos, gana el de menor
  /// [priority] (el orden de llegada desempata).
  final int priority;

  final AmbientAlertPresentation presentation;

  final AmbientUrgency urgency;

  final AmbientQuietHoursPolicy quietHours;

  final IconData icon;

  /// Título, ya traducido.
  final String title;

  /// Texto opcional, ya traducido.
  final String? message;

  final List<AmbientAlertAction> actions;

  /// Ruta absoluta de la pantalla propia del plugin para un aviso a pantalla
  /// completa con interacción especial (p. ej. mantener para apagar). Si es
  /// `null`, el host dibuja el aviso genérico con [title], [message] y
  /// [actions].
  final String? route;

  const AmbientAlert({
    required this.id,
    required this.sourceId,
    required this.priority,
    required this.presentation,
    required this.icon,
    required this.title,
    this.message,
    this.urgency = AmbientUrgency.normal,
    this.quietHours = AmbientQuietHoursPolicy.show,
    this.actions = const <AmbientAlertAction>[],
    this.route,
  });

  @override
  List<Object?> get props =>
      <Object?>[id, sourceId, priority, presentation, urgency, quietHours, icon, title, message, actions, route];

  @override
  bool get stringify => true;
}

/// Lo implementa un `HomePlugin` que publica avisos. Es opcional: el host lo
/// busca con un patrón de tipo sobre los plugins listos.
abstract interface class AmbientAlertSource {
  /// Emite la lista actual al suscribirse y la lista completa en cada cambio.
  /// Un aviso desaparece cuando deja de estar en la lista.
  Stream<List<AmbientAlert>> watchAlerts();

  /// El usuario pulsó [actionId] en el aviso [alertId].
  Future<void> onAction(String alertId, String actionId);
}
