import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'ambient_urgency.dart';

/// Cápsula de estado que un plugin publica para que el host la dibuje en su
/// pantalla principal (p. ej. «6:30» de la próxima alarma o «4:12» de un
/// temporizador), sin que el host importe el plugin.
///
/// Son datos, no widgets: el host decide el aspecto con su sistema de diseño.
/// Los textos llegan ya traducidos.
class AmbientStatus extends Equatable {
  /// Identificador estable dentro de [sourceId] (p. ej. `next_alarm`).
  final String id;

  /// `id` del plugin que lo publica.
  final String sourceId;

  final IconData icon;

  /// Texto principal, ya traducido.
  final String label;

  /// Texto secundario opcional, ya traducido.
  final String? detail;

  /// Etiqueta para lectores de pantalla, ya traducida.
  final String semanticLabel;

  /// Menor número, más prioridad: si no caben todos, el host muestra los de
  /// menor [priority].
  final int priority;

  final AmbientUrgency urgency;

  /// Ruta absoluta que abre el host al tocarlo, o `null` si no se puede tocar.
  final String? route;

  const AmbientStatus({
    required this.id,
    required this.sourceId,
    required this.icon,
    required this.label,
    required this.semanticLabel,
    required this.priority,
    this.detail,
    this.urgency = AmbientUrgency.normal,
    this.route,
  });

  @override
  List<Object?> get props => <Object?>[id, sourceId, icon, label, detail, semanticLabel, priority, urgency, route];

  @override
  bool get stringify => true;
}

/// Lo implementa un `HomePlugin` que publica cápsulas de estado. Es opcional:
/// el host lo busca con un patrón de tipo sobre los plugins listos.
abstract interface class AmbientStatusSource {
  /// Emite la lista actual al suscribirse y la lista completa en cada cambio.
  /// Una lista vacía significa que no hay nada que mostrar.
  Stream<List<AmbientStatus>> watchStatuses();
}
