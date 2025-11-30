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
	@override late final _TranslationsCommonJa common = _TranslationsCommonJa._(_root);
	@override late final _TranslationsHomeJa home = _TranslationsHomeJa._(_root);
	@override late final _TranslationsMapJa map = _TranslationsMapJa._(_root);
	@override late final _TranslationsWelcomeJa welcome = _TranslationsWelcomeJa._(_root);
	@override late final _TranslationsFinderJa finder = _TranslationsFinderJa._(_root);
	@override late final _TranslationsFinderWebJa finderWeb = _TranslationsFinderWebJa._(_root);
	@override late final _TranslationsShareJa share = _TranslationsShareJa._(_root);
}

// Path: common
class _TranslationsCommonJa implements TranslationsCommonEn {
	_TranslationsCommonJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'キャンセル';
	@override String get save => '保存';
	@override String get saving => '保存中...';
}

// Path: home
class _TranslationsHomeJa implements TranslationsHomeEn {
	_TranslationsHomeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'こえみゃく';
	@override String get emptyTitle => 'まだこえみゃくがありません';
	@override String get emptyMessage => '地図上でピンを追加して\n音声メモを残しましょう';
	@override String get errorLoading => '読み込みに失敗しました';
	@override String get retry => '再試行';
	@override String get play => '再生';
	@override String get edit => '編集';
	@override String get share => '共有';
	@override String get shareSubject => 'こえみゃくを共有';
	@override String get delete => '削除';
	@override String get deleteConfirmTitle => '削除の確認';
	@override String get deleteConfirmMessage => 'このこえみゃくを削除しますか？';
	@override String get deleteSuccess => '削除しました';
	@override String get deleteError => '削除に失敗しました';
	@override String get editKoemyaku => 'こえみゃくを編集';
	@override String get updateSuccess => '更新しました';
	@override String get updateError => '更新に失敗しました';
}

// Path: map
class _TranslationsMapJa implements TranslationsMapEn {
	_TranslationsMapJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get editTitle => 'タップして声を追加';
	@override late final _TranslationsMapMarkerBottomSheetJa markerBottomSheet = _TranslationsMapMarkerBottomSheetJa._(_root);
	@override String get saveKoemyaku => 'こえみゃくを保存';
	@override String get title => 'タイトル';
	@override String get titleHint => 'タイトルを入力';
	@override String get titleRequired => 'タイトルは必須です';
	@override String get message => 'メッセージ';
	@override String get messageHint => 'メッセージを入力（任意）';
	@override String get saveSuccess => '保存しました';
	@override String get saveError => '保存に失敗しました';
}

// Path: welcome
class _TranslationsWelcomeJa implements TranslationsWelcomeEn {
	_TranslationsWelcomeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'KoeMyaku';
	@override String get subtitle => '声で残す、場所の記憶';
	@override String get description => '地図上に音声メモを残して、\nあなただけの声の地図を作りましょう';
	@override String get startButton => 'はじめる';
}

// Path: finder
class _TranslationsFinderJa implements TranslationsFinderEn {
	_TranslationsFinderJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get initializing => '位置情報を取得中...';
	@override String findingVoice({required Object index, required Object total}) => '声を探しています (${index}/${total})';
	@override String get distanceAway => '先にあります';
	@override String get skip => 'スキップ';
	@override String get skipToNext => '次へスキップ';
	@override String get arrived => '到着しました！';
	@override String get allCompleted => 'すべて完了！';
	@override String get allCompletedMessage => 'すべての声を聴きました';
	@override String get completedTitle => '完了';
	@override String get completedMessage => 'すべてのこえみゃくを聴きました！お疲れ様でした。';
	@override String get finish => '終了';
	@override String get error => 'エラーが発生しました';
	@override String get close => '閉じる';
	@override String get noVoiceMarkers => '音声マーカーがありません';
}

// Path: finderWeb
class _TranslationsFinderWebJa implements TranslationsFinderWebEn {
	_TranslationsFinderWebJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get loading => '読み込み中...';
	@override String get notFound => 'こえみゃくが見つかりませんでした';
	@override String get permissionTitle => '位置情報とコンパスの許可';
	@override String get permissionMessage => 'この機能を使用するには、位置情報とコンパス（方位センサー）へのアクセスを許可してください。';
	@override String get permissionNote => 'iOSをお使いの場合は、下のボタンをタップして許可してください。';
	@override String get grantPermission => '許可する';
	@override String get permissionDenied => '許可が拒否されました';
	@override String get permissionDeniedMessage => '位置情報またはコンパスへのアクセスが拒否されました。ブラウザの設定から許可してください。';
	@override String get compassNotSupported => 'コンパスがサポートされていません';
	@override String get compassNotSupportedMessage => 'このデバイスまたはブラウザではコンパスがサポートされていません。位置情報のみで案内します。';
	@override String get continueAnyway => '続ける';
	@override String get backToHome => 'ホームに戻る';
}

// Path: share
class _TranslationsShareJa implements TranslationsShareEn {
	_TranslationsShareJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '共有';
	@override String get copyLink => 'リンクをコピー';
	@override String get linkCopied => 'リンクをコピーしました';
	@override String get close => '閉じる';
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
			'common.cancel' => 'キャンセル',
			'common.save' => '保存',
			'common.saving' => '保存中...',
			'home.title' => 'こえみゃく',
			'home.emptyTitle' => 'まだこえみゃくがありません',
			'home.emptyMessage' => '地図上でピンを追加して\n音声メモを残しましょう',
			'home.errorLoading' => '読み込みに失敗しました',
			'home.retry' => '再試行',
			'home.play' => '再生',
			'home.edit' => '編集',
			'home.share' => '共有',
			'home.shareSubject' => 'こえみゃくを共有',
			'home.delete' => '削除',
			'home.deleteConfirmTitle' => '削除の確認',
			'home.deleteConfirmMessage' => 'このこえみゃくを削除しますか？',
			'home.deleteSuccess' => '削除しました',
			'home.deleteError' => '削除に失敗しました',
			'home.editKoemyaku' => 'こえみゃくを編集',
			'home.updateSuccess' => '更新しました',
			'home.updateError' => '更新に失敗しました',
			'map.editTitle' => 'タップして声を追加',
			'map.markerBottomSheet.addPinConfirmation' => 'この場所にピンを追加しますか？',
			'map.markerBottomSheet.editPinConfirmation' => 'このピンを編集しますか？',
			'map.markerBottomSheet.latitude' => '緯度',
			'map.markerBottomSheet.longitude' => '経度',
			'map.markerBottomSheet.delete' => '削除',
			'map.markerBottomSheet.save' => '保存',
			'map.markerBottomSheet.close' => '閉じる',
			'map.markerBottomSheet.rangeLabel' => '範囲',
			'map.markerBottomSheet.rangeUnit' => 'm',
			'map.saveKoemyaku' => 'こえみゃくを保存',
			'map.title' => 'タイトル',
			'map.titleHint' => 'タイトルを入力',
			'map.titleRequired' => 'タイトルは必須です',
			'map.message' => 'メッセージ',
			'map.messageHint' => 'メッセージを入力（任意）',
			'map.saveSuccess' => '保存しました',
			'map.saveError' => '保存に失敗しました',
			'welcome.title' => 'KoeMyaku',
			'welcome.subtitle' => '声で残す、場所の記憶',
			'welcome.description' => '地図上に音声メモを残して、\nあなただけの声の地図を作りましょう',
			'welcome.startButton' => 'はじめる',
			'finder.initializing' => '位置情報を取得中...',
			'finder.findingVoice' => ({required Object index, required Object total}) => '声を探しています (${index}/${total})',
			'finder.distanceAway' => '先にあります',
			'finder.skip' => 'スキップ',
			'finder.skipToNext' => '次へスキップ',
			'finder.arrived' => '到着しました！',
			'finder.allCompleted' => 'すべて完了！',
			'finder.allCompletedMessage' => 'すべての声を聴きました',
			'finder.completedTitle' => '完了',
			'finder.completedMessage' => 'すべてのこえみゃくを聴きました！お疲れ様でした。',
			'finder.finish' => '終了',
			'finder.error' => 'エラーが発生しました',
			'finder.close' => '閉じる',
			'finder.noVoiceMarkers' => '音声マーカーがありません',
			'finderWeb.loading' => '読み込み中...',
			'finderWeb.notFound' => 'こえみゃくが見つかりませんでした',
			'finderWeb.permissionTitle' => '位置情報とコンパスの許可',
			'finderWeb.permissionMessage' => 'この機能を使用するには、位置情報とコンパス（方位センサー）へのアクセスを許可してください。',
			'finderWeb.permissionNote' => 'iOSをお使いの場合は、下のボタンをタップして許可してください。',
			'finderWeb.grantPermission' => '許可する',
			'finderWeb.permissionDenied' => '許可が拒否されました',
			'finderWeb.permissionDeniedMessage' => '位置情報またはコンパスへのアクセスが拒否されました。ブラウザの設定から許可してください。',
			'finderWeb.compassNotSupported' => 'コンパスがサポートされていません',
			'finderWeb.compassNotSupportedMessage' => 'このデバイスまたはブラウザではコンパスがサポートされていません。位置情報のみで案内します。',
			'finderWeb.continueAnyway' => '続ける',
			'finderWeb.backToHome' => 'ホームに戻る',
			'share.title' => '共有',
			'share.copyLink' => 'リンクをコピー',
			'share.linkCopied' => 'リンクをコピーしました',
			'share.close' => '閉じる',
			_ => null,
		};
	}
}
