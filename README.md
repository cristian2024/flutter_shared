# flutter_shared

Paquetes Flutter y Dart reutilizables entre proyectos. Monorepo Melos 8 con pub workspaces: cada paquete tiene su versión SemVer, su CHANGELOG y sus etiquetas.

| Paquete | Ruta | Qué hace |
| :--- | :--- | :--- |
| `core_di` | `packages/core/core_di` | `ServiceLocator` (envoltorio de `get_it` con scopes) y `DependencyModule` |
| `core_events` | `packages/core/core_events` | `EventBus` entre módulos y sus tests de contrato |
| `core_contracts` | `packages/core/core_contracts` | Contrato de plugin, ciclo de vida, preferencias, cápsulas de estado y avisos |
| `core_utils` | `packages/shared/core_utils` | `Clock`, `IdGenerator` (UUID v4) y `CalendarDay` |
| `core_ui` | `packages/shared/core_ui` | Coordinación de idioma con slang, traducciones inyectadas y `LanguageRebuilder` |
| `storage_isar` | `packages/adapters/storage_isar` | Adaptador de almacenamiento sobre `isar_community` |

## Cómo se consume

Cada versión publicada es una etiqueta `<paquete>-v<versión>`. El proyecto depende con un rango, como si fuera pub.dev (Dart 3.9 o posterior):

```yaml
dependencies:
  core_di:
    git:
      url: git@github.com:cristian2024/flutter_shared.git
      path: packages/core/core_di
      tag_pattern: core_di-v{{version}}
    version: ^0.1.2
```

Una versión nueva incompatible no llega a nadie hasta que el proyecto cambie su rango; las compatibles llegan con `pub upgrade`, y el `pubspec.lock` las deja fijas hasta entonces.

**Trabajar a la vez en un paquete y en un proyecto:** un `pubspec_overrides.yaml` local en el proyecto (ignorado por git) apunta el paquete a su carpeta en disco. Al terminar se publica la etiqueta y se borra el override.

## Desarrollo

```sh
melos bs           # resuelve el workspace y genera el código (Isar, slang)
melos run verify   # análisis + reglas de arquitectura + tests
```

Convenciones en [CLAUDE.md](CLAUDE.md).
