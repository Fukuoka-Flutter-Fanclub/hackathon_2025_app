///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsJa with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsJa _root = this; // ignore: unused_field

	@override 
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsMapJa map = _TranslationsMapJa._(_root);
}

// Path: map
class _TranslationsMapJa implements TranslationsMapEn {
	_TranslationsMapJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsMapMarkerBottomSheetJa markerBottomSheet = _TranslationsMapMarkerBottomSheetJa._(_root);
}

// Path: map.markerBottomSheet
class _TranslationsMapMarkerBottomSheetJa implements TranslationsMapMarkerBottomSheetEn {
	_TranslationsMapMarkerBottomSheetJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get addPinConfirmation => 'この場所にピンを追加しますか？';
	@override String get editPinConfirmation => 'このピンを編集しますか？';
	@override String get latitude => '緯度';
	@override String get longitude => '経度';
	@override String get delete => '削除';
	@override String get save => '保存';
	@override String get close => '閉じる';
	@override String get rangeLabel => '範囲';
	@override String get rangeUnit => 'm';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'map.markerBottomSheet.addPinConfirmation' => 'この場所にピンを追加しますか？',
			'map.markerBottomSheet.editPinConfirmation' => 'このピンを編集しますか？',
			'map.markerBottomSheet.latitude' => '緯度',
			'map.markerBottomSheet.longitude' => '経度',
			'map.markerBottomSheet.delete' => '削除',
			'map.markerBottomSheet.save' => '保存',
			'map.markerBottomSheet.close' => '閉じる',
			'map.markerBottomSheet.rangeLabel' => '範囲',
			'map.markerBottomSheet.rangeUnit' => 'm',
			_ => null,
		};
	}
}
