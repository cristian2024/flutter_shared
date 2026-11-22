# CLAUDE.md · flutter_shared

Paquetes compartidos entre proyectos (Alba, home_tasks…). Mismas convenciones que home_tasks y la skill `flutter-guidelines`; aquí solo lo propio de este repo.

## Comandos
- `melos bs`: resuelve el workspace y ejecuta `melos run gen` (Isar con build_runner, slang). Los `*.g.dart` no se versionan.
- `melos run verify`: `analyze` (`tool/analyze.dart`, falla con cualquier diagnóstico) + `verify:arch` (`tool/verify_architecture.dart`) + `test`.
- `melos run test:changed`: lo que ejecuta la CI en un PR.

## Estructura
- `packages/core/*`: contratos transversales. `packages/shared/*`: utilidades reutilizables. `packages/adapters/*`: tecnologías concretas (solo ellos importan motores de base de datos y SDKs de plataforma).
- Cada paquete declara `resolution: workspace` y queda cubierto por la lista `workspace:` del `pubspec.yaml` raíz. No hay `melos.yaml`.
- Entre paquetes del repo, `^x.y.z`, nunca `any`.

## Versiones y etiquetas
- Una rama (y un PR) por paquete; la raíz (`pubspec.yaml`, `tool/`, `.github/`, docs) es otro proyecto.
- Toda rama que cambia un paquete sube su `version:`, añade su entrada al CHANGELOG y actualiza su README (formato y SemVer de la skill).
- Tras el merge en `main`, la versión se publica con la etiqueta `<paquete>-v<versión>` sobre ese commit. Las etiquetas no se mueven ni se borran: los proyectos resuelven por ellas.
- Un cambio aquí nunca obliga a tocar un proyecto consumidor: cada uno sube su rango cuando quiere.
- **Etiquetas, commits y push solo cuando el usuario lo pida.**

## Paquetes concretos
- `storage_isar`: `isar_community` fijado en 3.4.1 (nunca `isar`). Los adaptadores de funcionalidad importan su API desde `package:storage_isar/adapter.dart`. En tests, `setUpAll(initializeIsarForTests)`.
- `core_contracts`: `HomePlugin` con interfaces opcionales que el host busca con un patrón de tipo (`HomePluginEntryRoute`, `AmbientStatusSource`, `AmbientAlertSource`). Prioridad: menor número, más prioridad.
- Todo contrato con varias implementaciones trae sus tests de contrato y un doble en memoria en `testing.dart`.
