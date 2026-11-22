import 'package:equatable/equatable.dart';

import 'ambient_alert.dart';
import 'ambient_status.dart';

/// Qué avisos y estados se ven en un momento dado.
class AmbientResolution extends Equatable {
  /// Aviso a pantalla completa visible, o `null`.
  final AmbientAlert? fullScreen;

  /// Avisos a pantalla completa en espera, por prioridad. Salen cuando
  /// desaparece [fullScreen].
  final List<AmbientAlert> queuedFullScreen;

  /// Banner visible, o `null`.
  final AmbientAlert? banner;

  /// Estados visibles, por prioridad.
  final List<AmbientStatus> statuses;

  const AmbientResolution({
    this.fullScreen,
    this.queuedFullScreen = const <AmbientAlert>[],
    this.banner,
    this.statuses = const <AmbientStatus>[],
  });

  @override
  List<Object?> get props => <Object?>[fullScreen, queuedFullScreen, banner, statuses];

  @override
  bool get stringify => true;
}

/// Reglas para decidir qué aviso gana si coinciden varios. Función pura.
///
/// - Gana el de menor `priority`; a igual prioridad, el que llegó antes.
/// - Las pantallas completas se ponen en cola.
/// - Solo cabe un banner.
/// - Caben como mucho [maxStatuses] estados.
/// - En horas de silencio ([quietHours]), los avisos con
///   [AmbientQuietHoursPolicy.defer] no se muestran.
abstract final class AmbientAlertResolver {
  static AmbientResolution resolve({
    required List<AmbientAlert> alerts,
    List<AmbientStatus> statuses = const <AmbientStatus>[],
    bool quietHours = false,
    int maxStatuses = 2,
  }) {
    final List<AmbientAlert> visible = _byPriority(<AmbientAlert>[
      for (final AmbientAlert alert in alerts)
        if (!quietHours || alert.quietHours == AmbientQuietHoursPolicy.show) alert,
    ], (AmbientAlert alert) => alert.priority);
    final List<AmbientAlert> fullScreen = <AmbientAlert>[
      for (final AmbientAlert alert in visible)
        if (alert.presentation == AmbientAlertPresentation.fullScreen) alert,
    ];
    final List<AmbientAlert> banners = <AmbientAlert>[
      for (final AmbientAlert alert in visible)
        if (alert.presentation == AmbientAlertPresentation.banner) alert,
    ];
    return AmbientResolution(
      fullScreen: fullScreen.isEmpty ? null : fullScreen.first,
      queuedFullScreen: fullScreen.skip(1).toList(),
      banner: banners.isEmpty ? null : banners.first,
      statuses: _byPriority(statuses, (AmbientStatus status) => status.priority).take(maxStatuses).toList(),
    );
  }

  /// Ordena por prioridad conservando el orden de llegada en los empates.
  static List<T> _byPriority<T>(List<T> items, int Function(T item) priorityOf) {
    final List<int> indexes = List<int>.generate(items.length, (int index) => index)
      ..sort((int a, int b) {
        final int byPriority = priorityOf(items[a]).compareTo(priorityOf(items[b]));
        return byPriority != 0 ? byPriority : a.compareTo(b);
      });
    return <T>[for (final int index in indexes) items[index]];
  }
}
