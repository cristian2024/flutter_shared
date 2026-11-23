///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'package:slang/overrides.dart';
import 'strings.g.dart';

// Path: <root>
class CoreUiTranslationsEn with BaseTranslations<CoreUiLocale, CoreUiTranslations> implements CoreUiTranslations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [CoreUiLocale.build] is preferred.
	/// [AppLocaleUtils.buildWithOverrides] is recommended for overriding.
	CoreUiTranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<CoreUiLocale, CoreUiTranslations>? meta})
		: _meta = meta ?? TranslationMetadata(
		    locale: CoreUiLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<CoreUiLocale, CoreUiTranslations> _meta;
	@override TranslationMetadata<CoreUiLocale, CoreUiTranslations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key);

	late final CoreUiTranslationsEn _root = this; // ignore: unused_field

	@override 
	CoreUiTranslationsEn $copyWith({TranslationMetadata<CoreUiLocale, CoreUiTranslations>? meta}) => CoreUiTranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _CoreUiTranslations$common$en common = _CoreUiTranslations$common$en._(_root);
}

// Path: common
class _CoreUiTranslations$common$en implements CoreUiTranslations$common$es {
	_CoreUiTranslations$common$en._(this._root);

	final CoreUiTranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get cancel => TranslationOverrides.string(_root.$meta, 'common.cancel', {}) ?? 'Cancel';
	@override String get confirm => TranslationOverrides.string(_root.$meta, 'common.confirm', {}) ?? 'Confirm';
	@override String get save => TranslationOverrides.string(_root.$meta, 'common.save', {}) ?? 'Save';
	@override String get retry => TranslationOverrides.string(_root.$meta, 'common.retry', {}) ?? 'Retry';
	@override String get close => TranslationOverrides.string(_root.$meta, 'common.close', {}) ?? 'Close';
	@override String get back => TranslationOverrides.string(_root.$meta, 'common.back', {}) ?? 'Back';
	@override String get loading => TranslationOverrides.string(_root.$meta, 'common.loading', {}) ?? 'Loading…';
	@override String get unexpectedError => TranslationOverrides.string(_root.$meta, 'common.unexpectedError', {}) ?? 'An unexpected error occurred.';
	@override String get requiredField => TranslationOverrides.string(_root.$meta, 'common.requiredField', {}) ?? 'This field is required.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on CoreUiTranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.cancel' => TranslationOverrides.string(_root.$meta, 'common.cancel', {}) ?? 'Cancel',
			'common.confirm' => TranslationOverrides.string(_root.$meta, 'common.confirm', {}) ?? 'Confirm',
			'common.save' => TranslationOverrides.string(_root.$meta, 'common.save', {}) ?? 'Save',
			'common.retry' => TranslationOverrides.string(_root.$meta, 'common.retry', {}) ?? 'Retry',
			'common.close' => TranslationOverrides.string(_root.$meta, 'common.close', {}) ?? 'Close',
			'common.back' => TranslationOverrides.string(_root.$meta, 'common.back', {}) ?? 'Back',
			'common.loading' => TranslationOverrides.string(_root.$meta, 'common.loading', {}) ?? 'Loading…',
			'common.unexpectedError' => TranslationOverrides.string(_root.$meta, 'common.unexpectedError', {}) ?? 'An unexpected error occurred.',
			'common.requiredField' => TranslationOverrides.string(_root.$meta, 'common.requiredField', {}) ?? 'This field is required.',
			_ => null,
		};
	}
}
