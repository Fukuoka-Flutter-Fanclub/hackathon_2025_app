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
class TranslationsZhTw with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsZhTw({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zhTw,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-TW>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsZhTw _root = this; // ignore: unused_field

	@override 
	TranslationsZhTw $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZhTw(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsMapZhTw map = _TranslationsMapZhTw._(_root);
}

// Path: map
class _TranslationsMapZhTw implements TranslationsMapEn {
	_TranslationsMapZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsMapMarkerBottomSheetZhTw markerBottomSheet = _TranslationsMapMarkerBottomSheetZhTw._(_root);
}

// Path: map.markerBottomSheet
class _TranslationsMapMarkerBottomSheetZhTw implements TranslationsMapMarkerBottomSheetEn {
	_TranslationsMapMarkerBottomSheetZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get addPinConfirmation => '要在此位置新增圖釘嗎？';
	@override String get latitude => '緯度';
	@override String get longitude => '經度';
	@override String get delete => '刪除';
	@override String get save => '儲存';
}

/// The flat map containing all translations for locale <zh-TW>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZhTw {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'map.markerBottomSheet.addPinConfirmation' => '要在此位置新增圖釘嗎？',
			'map.markerBottomSheet.latitude' => '緯度',
			'map.markerBottomSheet.longitude' => '經度',
			'map.markerBottomSheet.delete' => '刪除',
			'map.markerBottomSheet.save' => '儲存',
			_ => null,
		};
	}
}
