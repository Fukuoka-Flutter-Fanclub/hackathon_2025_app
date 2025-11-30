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
	@override late final _TranslationsCommonZhTw common = _TranslationsCommonZhTw._(_root);
	@override late final _TranslationsHomeZhTw home = _TranslationsHomeZhTw._(_root);
	@override late final _TranslationsMapZhTw map = _TranslationsMapZhTw._(_root);
	@override late final _TranslationsWelcomeZhTw welcome = _TranslationsWelcomeZhTw._(_root);
	@override late final _TranslationsFinderZhTw finder = _TranslationsFinderZhTw._(_root);
	@override late final _TranslationsFinderWebZhTw finderWeb = _TranslationsFinderWebZhTw._(_root);
}

// Path: common
class _TranslationsCommonZhTw implements TranslationsCommonEn {
	_TranslationsCommonZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get cancel => '取消';
	@override String get save => '儲存';
	@override String get saving => '儲存中...';
}

// Path: home
class _TranslationsHomeZhTw implements TranslationsHomeEn {
	_TranslationsHomeZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => '聲脈';
	@override String get emptyTitle => '還沒有聲脈';
	@override String get emptyMessage => '在地圖上新增圖釘\n並留下語音備忘';
	@override String get errorLoading => '載入失敗';
	@override String get retry => '重試';
	@override String get play => '播放';
	@override String get share => '分享';
	@override String get shareSubject => '分享聲脈';
	@override String get delete => '刪除';
	@override String get deleteConfirmTitle => '確認刪除';
	@override String get deleteConfirmMessage => '確定要刪除這個聲脈嗎？';
	@override String get deleteSuccess => '刪除成功';
	@override String get deleteError => '刪除失敗';
	@override String get editKoemyaku => '編輯聲脈';
	@override String get updateSuccess => '更新成功';
	@override String get updateError => '更新失敗';
}

// Path: map
class _TranslationsMapZhTw implements TranslationsMapEn {
	_TranslationsMapZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get editTitle => '點擊添加聲音';
	@override late final _TranslationsMapMarkerBottomSheetZhTw markerBottomSheet = _TranslationsMapMarkerBottomSheetZhTw._(_root);
	@override String get saveKoemyaku => '儲存聲脈';
	@override String get title => '標題';
	@override String get titleHint => '輸入標題';
	@override String get titleRequired => '標題為必填';
	@override String get message => '訊息';
	@override String get messageHint => '輸入訊息（選填）';
	@override String get saveSuccess => '儲存成功';
	@override String get saveError => '儲存失敗';
}

// Path: welcome
class _TranslationsWelcomeZhTw implements TranslationsWelcomeEn {
	_TranslationsWelcomeZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get title => 'KoeMyaku';
	@override String get subtitle => '用聲音保存地點的記憶';
	@override String get description => '在地圖上留下語音備忘，\n創建屬於您的聲音地圖';
	@override String get startButton => '開始使用';
}

// Path: finder
class _TranslationsFinderZhTw implements TranslationsFinderEn {
	_TranslationsFinderZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get initializing => '取得位置中...';
	@override String findingVoice({required Object index, required Object total}) => '尋找聲音 (${index}/${total})';
	@override String get distanceAway => '之外';
	@override String get skip => '跳過';
	@override String get skipToNext => '跳到下一個';
	@override String get arrived => '已到達！';
	@override String get allCompleted => '全部完成！';
	@override String get allCompletedMessage => '已聆聽所有聲音';
	@override String get completedTitle => '完成';
	@override String get completedMessage => '已聆聽所有聲脈！辛苦了。';
	@override String get finish => '結束';
	@override String get error => '發生錯誤';
	@override String get close => '關閉';
	@override String get noVoiceMarkers => '找不到語音標記';
}

// Path: finderWeb
class _TranslationsFinderWebZhTw implements TranslationsFinderWebEn {
	_TranslationsFinderWebZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get loading => '載入中...';
	@override String get notFound => '找不到聲脈';
	@override String get permissionTitle => '位置和指南針權限';
	@override String get permissionMessage => '要使用此功能，請允許存取您的位置和指南針（方向感應器）。';
	@override String get permissionNote => '如果您使用的是 iOS，請點擊下方按鈕授予權限。';
	@override String get grantPermission => '授予權限';
	@override String get permissionDenied => '權限被拒絕';
	@override String get permissionDeniedMessage => '位置或指南針的存取權限被拒絕。請在瀏覽器設定中允許。';
	@override String get compassNotSupported => '不支援指南針';
	@override String get compassNotSupportedMessage => '此裝置或瀏覽器不支援指南針。我們將僅使用位置資訊進行導航。';
	@override String get continueAnyway => '繼續';
	@override String get backToHome => '返回首頁';
}

// Path: map.markerBottomSheet
class _TranslationsMapMarkerBottomSheetZhTw implements TranslationsMapMarkerBottomSheetEn {
	_TranslationsMapMarkerBottomSheetZhTw._(this._root);

	final TranslationsZhTw _root; // ignore: unused_field

	// Translations
	@override String get addPinConfirmation => '要在此位置新增圖釘嗎？';
	@override String get editPinConfirmation => '要編輯此圖釘嗎？';
	@override String get latitude => '緯度';
	@override String get longitude => '經度';
	@override String get delete => '刪除';
	@override String get save => '儲存';
	@override String get close => '關閉';
	@override String get rangeLabel => '範圍';
	@override String get rangeUnit => 'm';
}

/// The flat map containing all translations for locale <zh-TW>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZhTw {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.cancel' => '取消',
			'common.save' => '儲存',
			'common.saving' => '儲存中...',
			'home.title' => '聲脈',
			'home.emptyTitle' => '還沒有聲脈',
			'home.emptyMessage' => '在地圖上新增圖釘\n並留下語音備忘',
			'home.errorLoading' => '載入失敗',
			'home.retry' => '重試',
			'home.play' => '播放',
			'home.share' => '分享',
			'home.shareSubject' => '分享聲脈',
			'home.delete' => '刪除',
			'home.deleteConfirmTitle' => '確認刪除',
			'home.deleteConfirmMessage' => '確定要刪除這個聲脈嗎？',
			'home.deleteSuccess' => '刪除成功',
			'home.deleteError' => '刪除失敗',
			'home.editKoemyaku' => '編輯聲脈',
			'home.updateSuccess' => '更新成功',
			'home.updateError' => '更新失敗',
			'map.editTitle' => '點擊添加聲音',
			'map.markerBottomSheet.addPinConfirmation' => '要在此位置新增圖釘嗎？',
			'map.markerBottomSheet.editPinConfirmation' => '要編輯此圖釘嗎？',
			'map.markerBottomSheet.latitude' => '緯度',
			'map.markerBottomSheet.longitude' => '經度',
			'map.markerBottomSheet.delete' => '刪除',
			'map.markerBottomSheet.save' => '儲存',
			'map.markerBottomSheet.close' => '關閉',
			'map.markerBottomSheet.rangeLabel' => '範圍',
			'map.markerBottomSheet.rangeUnit' => 'm',
			'map.saveKoemyaku' => '儲存聲脈',
			'map.title' => '標題',
			'map.titleHint' => '輸入標題',
			'map.titleRequired' => '標題為必填',
			'map.message' => '訊息',
			'map.messageHint' => '輸入訊息（選填）',
			'map.saveSuccess' => '儲存成功',
			'map.saveError' => '儲存失敗',
			'welcome.title' => 'KoeMyaku',
			'welcome.subtitle' => '用聲音保存地點的記憶',
			'welcome.description' => '在地圖上留下語音備忘，\n創建屬於您的聲音地圖',
			'welcome.startButton' => '開始使用',
			'finder.initializing' => '取得位置中...',
			'finder.findingVoice' => ({required Object index, required Object total}) => '尋找聲音 (${index}/${total})',
			'finder.distanceAway' => '之外',
			'finder.skip' => '跳過',
			'finder.skipToNext' => '跳到下一個',
			'finder.arrived' => '已到達！',
			'finder.allCompleted' => '全部完成！',
			'finder.allCompletedMessage' => '已聆聽所有聲音',
			'finder.completedTitle' => '完成',
			'finder.completedMessage' => '已聆聽所有聲脈！辛苦了。',
			'finder.finish' => '結束',
			'finder.error' => '發生錯誤',
			'finder.close' => '關閉',
			'finder.noVoiceMarkers' => '找不到語音標記',
			'finderWeb.loading' => '載入中...',
			'finderWeb.notFound' => '找不到聲脈',
			'finderWeb.permissionTitle' => '位置和指南針權限',
			'finderWeb.permissionMessage' => '要使用此功能，請允許存取您的位置和指南針（方向感應器）。',
			'finderWeb.permissionNote' => '如果您使用的是 iOS，請點擊下方按鈕授予權限。',
			'finderWeb.grantPermission' => '授予權限',
			'finderWeb.permissionDenied' => '權限被拒絕',
			'finderWeb.permissionDeniedMessage' => '位置或指南針的存取權限被拒絕。請在瀏覽器設定中允許。',
			'finderWeb.compassNotSupported' => '不支援指南針',
			'finderWeb.compassNotSupportedMessage' => '此裝置或瀏覽器不支援指南針。我們將僅使用位置資訊進行導航。',
			'finderWeb.continueAnyway' => '繼續',
			'finderWeb.backToHome' => '返回首頁',
			_ => null,
		};
	}
}
