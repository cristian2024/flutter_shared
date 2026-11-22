import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';

import '../ambient_alert.dart';
import '../ambient_status.dart';

/// Tests de contrato de [AmbientStatusSource]. Todo plugin que publique
/// cápsulas debe pasarlos.
///
/// [create] devuelve la fuente lista para usar; [change] (opcional) provoca un
/// cambio en lo que publica, para comprobar que se emite de nuevo.
void ambientStatusSourceContract(
  String implementation, {
  required FutureOr<AmbientStatusSource> Function() create,
  FutureOr<void> Function(AmbientStatusSource source)? change,
  FutureOr<void> Function(AmbientStatusSource source)? dispose,
}) {
  group('AmbientStatusSource ($implementation)', () {
    late AmbientStatusSource source;

    setUp(() async => source = await create());
    tearDown(() async => dispose?.call(source));

    test('emite la lista actual al suscribirse', () async {
      await expectLater(source.watchStatuses(), emits(isA<List<AmbientStatus>>()));
    });

    test('los estados no repiten id y vienen de una sola fuente', () async {
      final List<AmbientStatus> statuses = await source.watchStatuses().first;

      expect(statuses.map((AmbientStatus status) => status.id).toSet(), hasLength(statuses.length));
      expect(statuses.map((AmbientStatus status) => status.sourceId).toSet().length, lessThanOrEqualTo(1));
    });

    if (change != null) {
      test('emite de nuevo al cambiar', () async {
        final StreamQueue<List<AmbientStatus>> queue = StreamQueue<List<AmbientStatus>>(source.watchStatuses());
        final List<AmbientStatus> initial = await queue.next;
        await change(source);

        expect(await queue.next, isNot(initial));
        await queue.cancel();
      });
    }
  });
}

/// Tests de contrato de [AmbientAlertSource]. Todo plugin que publique
/// avisos debe pasarlos. Los parámetros son como los de
/// [ambientStatusSourceContract].
void ambientAlertSourceContract(
  String implementation, {
  required FutureOr<AmbientAlertSource> Function() create,
  FutureOr<void> Function(AmbientAlertSource source)? change,
  FutureOr<void> Function(AmbientAlertSource source)? dispose,
}) {
  group('AmbientAlertSource ($implementation)', () {
    late AmbientAlertSource source;

    setUp(() async => source = await create());
    tearDown(() async => dispose?.call(source));

    test('emite la lista actual al suscribirse', () async {
      await expectLater(source.watchAlerts(), emits(isA<List<AmbientAlert>>()));
    });

    test('los avisos no repiten id, vienen de una sola fuente y sus acciones no repiten id', () async {
      final List<AmbientAlert> alerts = await source.watchAlerts().first;

      expect(alerts.map((AmbientAlert alert) => alert.id).toSet(), hasLength(alerts.length));
      expect(alerts.map((AmbientAlert alert) => alert.sourceId).toSet().length, lessThanOrEqualTo(1));
      for (final AmbientAlert alert in alerts) {
        expect(alert.actions.map((AmbientAlertAction action) => action.id).toSet(), hasLength(alert.actions.length));
      }
    });

    test('onAction con un aviso que no existe no falla', () async {
      await source.onAction('no-existe', 'no-existe');
    });

    if (change != null) {
      test('emite de nuevo al cambiar', () async {
        final StreamQueue<List<AmbientAlert>> queue = StreamQueue<List<AmbientAlert>>(source.watchAlerts());
        final List<AmbientAlert> initial = await queue.next;
        await change(source);

        expect(await queue.next, isNot(initial));
        await queue.cancel();
      });
    }
  });
}
