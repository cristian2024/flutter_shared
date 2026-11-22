import 'package:core_contracts/core_contracts.dart';
import 'package:core_contracts/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const IconData _icon = IconData(0xe000);

AmbientStatus _status(String id, int priority, {String sourceId = 'clock'}) =>
    AmbientStatus(id: id, sourceId: sourceId, icon: _icon, label: id, semanticLabel: id, priority: priority);

AmbientAlert _alert(
  String id,
  int priority,
  AmbientAlertPresentation presentation, {
  AmbientQuietHoursPolicy quietHours = AmbientQuietHoursPolicy.show,
}) =>
    AmbientAlert(
      id: id,
      sourceId: 'battery',
      priority: priority,
      presentation: presentation,
      icon: _icon,
      title: id,
      quietHours: quietHours,
    );

class _Plugin extends HomePlugin {
  @override
  String get id => 'minimal';

  @override
  String get nameKey => 'minimal.name';

  @override
  String get descriptionKey => 'minimal.description';

  @override
  IconData get icon => _icon;

  @override
  String get version => '1.0.0';

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> dispose() async {}

  @override
  List<RouteBase> get routes => <RouteBase>[];
}

class _AmbientPlugin extends _Plugin implements AmbientStatusSource {
  @override
  Stream<List<AmbientStatus>> watchStatuses() => Stream<List<AmbientStatus>>.value(<AmbientStatus>[_status('a', 1)]);
}

void main() {
  testWidgets('la tarjeta del inicio es opcional y por defecto no dibuja nada', (WidgetTester tester) async {
    await tester.pumpWidget(Builder(builder: (BuildContext context) => _Plugin().buildDashboardTile(context)));

    expect(find.byType(SizedBox), findsOneWidget);
  });

  test('las fuentes ambientales son opcionales: el host las busca con un patrón de tipo', () {
    final List<HomePlugin> plugins = <HomePlugin>[_Plugin(), _AmbientPlugin()];

    expect(plugins.whereType<AmbientStatusSource>(), hasLength(1));
  });

  group('AmbientAlertResolver', () {
    test('sin avisos ni estados no muestra nada', () {
      expect(AmbientAlertResolver.resolve(alerts: <AmbientAlert>[]), const AmbientResolution());
    });

    test('gana la pantalla completa de menor prioridad y las demás quedan en cola', () {
      final AmbientAlert alarm = _alert('alarm', 1, AmbientAlertPresentation.fullScreen);
      final AmbientAlert timer = _alert('timer', 2, AmbientAlertPresentation.fullScreen);
      final AmbientAlert critical = _alert('critical', 3, AmbientAlertPresentation.fullScreen);

      final AmbientResolution resolution =
          AmbientAlertResolver.resolve(alerts: <AmbientAlert>[critical, alarm, timer]);

      expect(resolution.fullScreen, alarm);
      expect(resolution.queuedFullScreen, <AmbientAlert>[timer, critical]);
    });

    test('solo cabe un banner y a igual prioridad gana el que llegó antes', () {
      final AmbientAlert first = _alert('first', 5, AmbientAlertPresentation.banner);
      final AmbientAlert second = _alert('second', 5, AmbientAlertPresentation.banner);
      final AmbientAlert low = _alert('low', 7, AmbientAlertPresentation.banner);

      final AmbientResolution resolution = AmbientAlertResolver.resolve(alerts: <AmbientAlert>[low, first, second]);

      expect(resolution.banner, first);
      expect(resolution.fullScreen, isNull);
    });

    test('en horas de silencio oculta los avisos que esperan', () {
      final AmbientAlert low = _alert('low', 7, AmbientAlertPresentation.banner, quietHours: AmbientQuietHoursPolicy.defer);
      final AmbientAlert permission = _alert('permission', 4, AmbientAlertPresentation.banner);

      expect(AmbientAlertResolver.resolve(alerts: <AmbientAlert>[low], quietHours: true).banner, isNull);
      expect(AmbientAlertResolver.resolve(alerts: <AmbientAlert>[low]).banner, low);
      expect(AmbientAlertResolver.resolve(alerts: <AmbientAlert>[low, permission], quietHours: true).banner, permission);
    });

    test('muestra como mucho maxStatuses estados, por prioridad', () {
      final AmbientStatus timer = _status('timer', 2);
      final AmbientStatus alarm = _status('alarm', 1);
      final AmbientStatus sound = _status('sound', 3);

      expect(
        AmbientAlertResolver.resolve(alerts: <AmbientAlert>[], statuses: <AmbientStatus>[sound, timer, alarm]).statuses,
        <AmbientStatus>[alarm, timer],
      );
      expect(
        AmbientAlertResolver.resolve(alerts: <AmbientAlert>[], statuses: <AmbientStatus>[sound, alarm], maxStatuses: 1)
            .statuses,
        <AmbientStatus>[alarm],
      );
    });
  });

  group('igualdad por valor', () {
    test('AmbientStatus, AmbientAlert y AmbientAlertAction', () {
      const AmbientAlertAction action = AmbientAlertAction(id: 'snooze', label: 'Posponer', isPrimary: true);

      expect(_status('a', 1), _status('a', 1));
      expect(_status('a', 1), isNot(_status('a', 2)));
      expect(
        _alert('a', 1, AmbientAlertPresentation.banner),
        isNot(_alert('a', 1, AmbientAlertPresentation.fullScreen)),
      );
      expect(action, const AmbientAlertAction(id: 'snooze', label: 'Posponer', isPrimary: true));
      expect(action.toString(), contains('snooze'));
      expect(_status('a', 1).toString(), contains('AmbientStatus'));
      expect(_alert('a', 1, AmbientAlertPresentation.banner).toString(), contains('AmbientAlert'));
      expect(const AmbientResolution().toString(), contains('AmbientResolution'));
    });
  });

  ambientStatusSourceContract(
    'InMemoryAmbientStatusSource',
    create: () => InMemoryAmbientStatusSource(<AmbientStatus>[_status('alarm', 1)]),
    change: (AmbientStatusSource source) => (source as InMemoryAmbientStatusSource).set(<AmbientStatus>[]),
    dispose: (AmbientStatusSource source) => (source as InMemoryAmbientStatusSource).close(),
  );

  ambientAlertSourceContract(
    'InMemoryAmbientAlertSource',
    create: () => InMemoryAmbientAlertSource(<AmbientAlert>[_alert('low', 7, AmbientAlertPresentation.banner)]),
    change: (AmbientAlertSource source) => (source as InMemoryAmbientAlertSource).set(<AmbientAlert>[]),
    dispose: (AmbientAlertSource source) => (source as InMemoryAmbientAlertSource).close(),
  );

  test('InMemoryAmbientAlertSource anota las acciones y expone lo actual', () async {
    final InMemoryAmbientAlertSource source = InMemoryAmbientAlertSource();
    await source.onAction('low', 'see');

    expect(source.actions, <(String, String)>[('low', 'see')]);
    expect(source.current, isEmpty);
    expect(InMemoryAmbientStatusSource().current, isEmpty);
    await source.close();
  });
}
