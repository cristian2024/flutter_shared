/// Dobles de prueba de los contratos y tests de contrato reutilizables, para
/// los tests de otros paquetes.
library;

import 'dart:async';

import 'core_contracts.dart';

export 'src/testing/ambient_source_contracts.dart';
export 'src/testing/plugin_preference_repository_contract.dart';

/// [PluginPreferenceRepository] en memoria. Cumple
/// [pluginPreferenceRepositoryContract].
class InMemoryPluginPreferenceRepository implements PluginPreferenceRepository {
  final Map<String, UserPluginPreference> _store = <String, UserPluginPreference>{};
  final StreamController<List<UserPluginPreference>> _changes =
      StreamController<List<UserPluginPreference>>.broadcast();

  @override
  Future<List<UserPluginPreference>> getAll() async => _store.values.toList();

  @override
  Future<void> save(UserPluginPreference preference) => saveAll(<UserPluginPreference>[preference]);

  @override
  Future<void> saveAll(List<UserPluginPreference> preferences) async {
    for (final UserPluginPreference preference in preferences) {
      _store[preference.pluginId] = preference;
    }
    _changes.add(_store.values.toList());
  }

  /// Emite el estado actual al suscribirse y la lista completa en cada cambio.
  @override
  Stream<List<UserPluginPreference>> watch() {
    StreamSubscription<List<UserPluginPreference>>? changes;
    late final StreamController<List<UserPluginPreference>> controller;
    controller = StreamController<List<UserPluginPreference>>(
      onListen: () {
        controller.add(_store.values.toList());
        changes = _changes.stream.listen(controller.add);
      },
      // No devuelve el futuro de cancel(): `first` lo esperaría y, con el
      // reloj simulado de testWidgets, no se completa.
      onCancel: () {
        unawaited(changes?.cancel());
        unawaited(controller.close());
      },
    );
    return controller.stream;
  }

  Future<void> close() => _changes.close();
}

/// [AmbientStatusSource] en memoria: publica lo que se le pasa con [set].
/// Cumple [ambientStatusSourceContract].
class InMemoryAmbientStatusSource implements AmbientStatusSource {
  InMemoryAmbientStatusSource([List<AmbientStatus> initial = const <AmbientStatus>[]]) : _current = initial;

  List<AmbientStatus> _current;
  final StreamController<List<AmbientStatus>> _changes = StreamController<List<AmbientStatus>>.broadcast();

  List<AmbientStatus> get current => _current;

  void set(List<AmbientStatus> statuses) {
    _current = statuses;
    _changes.add(statuses);
  }

  @override
  Stream<List<AmbientStatus>> watchStatuses() => _replayCurrent(() => _current, _changes.stream);

  Future<void> close() => _changes.close();
}

/// [AmbientAlertSource] en memoria: publica lo que se le pasa con [set] y
/// anota las acciones pulsadas en [actions]. Cumple
/// [ambientAlertSourceContract].
class InMemoryAmbientAlertSource implements AmbientAlertSource {
  InMemoryAmbientAlertSource([List<AmbientAlert> initial = const <AmbientAlert>[]]) : _current = initial;

  List<AmbientAlert> _current;
  final StreamController<List<AmbientAlert>> _changes = StreamController<List<AmbientAlert>>.broadcast();

  /// Acciones pulsadas, como `(alertId, actionId)`, en orden.
  final List<(String, String)> actions = <(String, String)>[];

  List<AmbientAlert> get current => _current;

  void set(List<AmbientAlert> alerts) {
    _current = alerts;
    _changes.add(alerts);
  }

  @override
  Stream<List<AmbientAlert>> watchAlerts() => _replayCurrent(() => _current, _changes.stream);

  @override
  Future<void> onAction(String alertId, String actionId) async => actions.add((alertId, actionId));

  Future<void> close() => _changes.close();
}

/// Emite [current] al suscribirse y después lo que llegue por [changes].
Stream<T> _replayCurrent<T>(T Function() current, Stream<T> changes) {
  StreamSubscription<T>? subscription;
  late final StreamController<T> controller;
  controller = StreamController<T>(
    onListen: () {
      controller.add(current());
      subscription = changes.listen(controller.add);
    },
    // No devuelve el futuro de cancel(): `first` lo esperaría y, con el
    // reloj simulado de testWidgets, no se completa.
    onCancel: () {
      unawaited(subscription?.cancel());
      unawaited(controller.close());
    },
  );
  return controller.stream;
}
