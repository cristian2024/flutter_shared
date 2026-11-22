/// Cuánto debe llamar la atención un estado o un aviso ambiental. El host lo
/// traduce a colores e iconos de su sistema de diseño.
enum AmbientUrgency {
  /// Informativo (próxima alarma, sonido reproduciéndose).
  normal,

  /// Requiere atención pronto (batería baja, temperatura alta).
  warning,

  /// Requiere atención ya (alarmas sin permiso, batería crítica).
  urgent,
}
