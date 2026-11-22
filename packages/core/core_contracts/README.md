# core_contracts

Contratos del sistema de plugins: qué es un plugin, cómo se registra, qué prefiere el usuario y en qué estado está cada uno.

## Contenido

- **`HomePlugin`**: lo que implementa cada plugin.
  - Identidad: `id`, `nameKey` y `descriptionKey` (claves i18n), `icon`, `version`.
  - Ciclo de vida: `isAvailable()`, `initialize()` y `dispose()`.
  - Lo que aporta: sus rutas (`routes`, de `go_router`) y, si el inicio usa tarjetas, su tarjeta (`buildDashboardTile`, opcional: por defecto no dibuja nada).
- **`HomePluginEntryRoute`** (opcional): la ruta de la pantalla principal (`entryRoute`). Con ella, la grilla del inicio abre el plugin directamente en lugar de mostrar su tarjeta.
- **`AmbientStatusSource`** (opcional): el plugin publica cápsulas de estado (`AmbientStatus`) como datos, con icono, texto ya traducido, prioridad (menor número, más prioridad), urgencia y ruta al tocarla. El host las dibuja en su pantalla principal sin importar el plugin.
- **`AmbientAlertSource`** (opcional): el plugin publica avisos (`AmbientAlert`) a pantalla completa o como banner, con acciones (`AmbientAlertAction`) que el host le devuelve con `onAction`. Un aviso con `route` usa la pantalla propia del plugin.
- **`AmbientAlertResolver`**: función pura que decide qué se ve si coinciden varios avisos. Gana el de menor prioridad; las pantallas completas se ponen en cola; solo cabe un banner; como mucho `maxStatuses` estados; en horas de silencio se ocultan los avisos con `AmbientQuietHoursPolicy.defer`.
- **`PluginRegistry`**: registro de los plugins en tiempo de compilación. Rechaza IDs duplicados.
- **`UserPluginPreference`** (activado y orden) y **`PluginPreferenceRepository`**: dónde se guarda. Cada motor de base de datos lo implementa en su adaptador.
- **`PluginLifecycleManager`**: aplica el ciclo Existencia → Disponibilidad → Activación → Inicialización.
  - `load()` devuelve un `PluginState` por plugin (`PluginStatus`: `unavailable`, `disabled`, `failed` o `ready`).
  - `setEnabled()` y `reorder()` guardan las preferencias.
  - Un plugin que falla nunca bloquea a los demás.

## Uso

La app registra sus plugins en un `PluginRegistry` y deja que `PluginLifecycleManager` los inicialice según las preferencias del usuario. Desactivar un plugin llama a su `dispose()` sin tocar sus datos.

## Fuentes ambientales en el host

```dart
final List<AmbientStatusSource> sources = readyPlugins.whereType<AmbientStatusSource>().toList();
final AmbientResolution visible = AmbientAlertResolver.resolve(alerts: alerts, statuses: statuses, quietHours: isNight);
```

## Tests

`package:core_contracts/testing.dart` trae los tests de contrato `pluginPreferenceRepositoryContract` (toda implementación de `PluginPreferenceRepository`), `ambientStatusSourceContract` y `ambientAlertSourceContract` (todo plugin que publique cápsulas o avisos), y los dobles en memoria `InMemoryPluginPreferenceRepository`, `InMemoryAmbientStatusSource` e `InMemoryAmbientAlertSource`.

```sh
flutter test
```
