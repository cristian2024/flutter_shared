///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef CoreUiTranslationsEs = CoreUiTranslations; // ignore: unused_element
class CoreUiTranslations with BaseTranslations<CoreUiLocale, CoreUiTranslations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final commonStrings = CoreUiTranslations.of(context);
	static CoreUiTranslations of(BuildContext context) => InheritedLocaleData.of<CoreUiLocale, CoreUiTranslations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [CoreUiLocale.build] is preferred.
	/// [AppLocaleUtils.buildWithOverrides] is recommended for overriding.
	CoreUiTranslations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<CoreUiLocale, CoreUiTranslations>? meta})
		: _meta = meta ?? TranslationMetadata(
		    locale: CoreUiLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	final TranslationMetadata<CoreUiLocale, CoreUiTranslations> _meta;
	@override TranslationMetadata<CoreUiLocale, CoreUiTranslations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final CoreUiTranslations _root = this; // ignore: unused_field

	CoreUiTranslations $copyWith({TranslationMetadata<CoreUiLocale, CoreUiTranslations>? meta}) => CoreUiTranslations(meta: meta ?? this.$meta);

	// Translations
	late final CoreUiTranslations$common$es common = CoreUiTranslations$common$es._(_root);
}

// Path: common
class CoreUiTranslations$common$es {
	CoreUiTranslations$common$es._(this._root);

	final CoreUiTranslations _root; // ignore: unused_field

	// Translations

	/// es: 'Cancelar'
	String get cancel => TranslationOverrides.string(_root.$meta, 'common.cancel', {}) ?? 'Cancelar';

	/// es: 'Confirmar'
	String get confirm => TranslationOverrides.string(_root.$meta, 'common.confirm', {}) ?? 'Confirmar';

	/// es: 'Guardar'
	String get save => TranslationOverrides.string(_root.$meta, 'common.save', {}) ?? 'Guardar';

	/// es: 'Reintentar'
	String get retry => TranslationOverrides.string(_root.$meta, 'common.retry', {}) ?? 'Reintentar';

	/// es: 'Cerrar'
	String get close => TranslationOverrides.string(_root.$meta, 'common.close', {}) ?? 'Cerrar';

	/// es: 'Volver'
	String get back => TranslationOverrides.string(_root.$meta, 'common.back', {}) ?? 'Volver';

	/// es: 'Cargando…'
	String get loading => TranslationOverrides.string(_root.$meta, 'common.loading', {}) ?? 'Cargando…';

	/// es: 'Ocurrió un error inesperado.'
	String get unexpectedError => TranslationOverrides.string(_root.$meta, 'common.unexpectedError', {}) ?? 'Ocurrió un error inesperado.';

	/// es: 'Este campo es obligatorio.'
	String get requiredField => TranslationOverrides.string(_root.$meta, 'common.requiredField', {}) ?? 'Este campo es obligatorio.';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on CoreUiTranslations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.cancel' => TranslationOverrides.string(_root.$meta, 'common.cancel', {}) ?? 'Cancelar',
			'common.confirm' => TranslationOverrides.string(_root.$meta, 'common.confirm', {}) ?? 'Confirmar',
			'common.save' => TranslationOverrides.string(_root.$meta, 'common.save', {}) ?? 'Guardar',
			'common.retry' => TranslationOverrides.string(_root.$meta, 'common.retry', {}) ?? 'Reintentar',
			'common.close' => TranslationOverrides.string(_root.$meta, 'common.close', {}) ?? 'Cerrar',
			'common.back' => TranslationOverrides.string(_root.$meta, 'common.back', {}) ?? 'Volver',
			'common.loading' => TranslationOverrides.string(_root.$meta, 'common.loading', {}) ?? 'Cargando…',
			'common.unexpectedError' => TranslationOverrides.string(_root.$meta, 'common.unexpectedError', {}) ?? 'Ocurrió un error inesperado.',
			'common.requiredField' => TranslationOverrides.string(_root.$meta, 'common.requiredField', {}) ?? 'Este campo es obligatorio.',
			_ => null,
		};
	}
}
