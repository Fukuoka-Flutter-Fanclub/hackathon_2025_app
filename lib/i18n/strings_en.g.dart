///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsMapEn map = TranslationsMapEn._(_root);
	late final TranslationsWelcomeEn welcome = TranslationsWelcomeEn._(_root);
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Saving...'
	String get saving => 'Saving...';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'KoeMyaku'
	String get title => 'KoeMyaku';

	/// en: 'No KoeMyaku yet'
	String get emptyTitle => 'No KoeMyaku yet';

	/// en: 'Add pins on the map and leave voice memos'
	String get emptyMessage => 'Add pins on the map\nand leave voice memos';

	/// en: 'Failed to load'
	String get errorLoading => 'Failed to load';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Play'
	String get play => 'Play';

	/// en: 'Share'
	String get share => 'Share';

	/// en: 'Share KoeMyaku'
	String get shareSubject => 'Share KoeMyaku';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Confirm Delete'
	String get deleteConfirmTitle => 'Confirm Delete';

	/// en: 'Are you sure you want to delete this KoeMyaku?'
	String get deleteConfirmMessage => 'Are you sure you want to delete this KoeMyaku?';

	/// en: 'Deleted successfully'
	String get deleteSuccess => 'Deleted successfully';

	/// en: 'Failed to delete'
	String get deleteError => 'Failed to delete';

	/// en: 'Edit KoeMyaku'
	String get editKoemyaku => 'Edit KoeMyaku';

	/// en: 'Updated successfully'
	String get updateSuccess => 'Updated successfully';

	/// en: 'Failed to update'
	String get updateError => 'Failed to update';
}

// Path: map
class TranslationsMapEn {
	TranslationsMapEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsMapMarkerBottomSheetEn markerBottomSheet = TranslationsMapMarkerBottomSheetEn._(_root);

	/// en: 'Save Koemyaku'
	String get saveKoemyaku => 'Save Koemyaku';

	/// en: 'Title'
	String get title => 'Title';

	/// en: 'Enter title'
	String get titleHint => 'Enter title';

	/// en: 'Title is required'
	String get titleRequired => 'Title is required';

	/// en: 'Message'
	String get message => 'Message';

	/// en: 'Enter message (optional)'
	String get messageHint => 'Enter message (optional)';

	/// en: 'Saved successfully'
	String get saveSuccess => 'Saved successfully';

	/// en: 'Failed to save'
	String get saveError => 'Failed to save';
}

// Path: welcome
class TranslationsWelcomeEn {
	TranslationsWelcomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'KoeMyaku'
	String get title => 'KoeMyaku';

	/// en: 'Memories of places, preserved in voice'
	String get subtitle => 'Memories of places, preserved in voice';

	/// en: 'Leave voice memos on the map and create your own voice map'
	String get description => 'Leave voice memos on the map\nand create your own voice map';

	/// en: 'Get Started'
	String get startButton => 'Get Started';
}

// Path: map.markerBottomSheet
class TranslationsMapMarkerBottomSheetEn {
	TranslationsMapMarkerBottomSheetEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add a pin to this location?'
	String get addPinConfirmation => 'Add a pin to this location?';

	/// en: 'Edit this pin?'
	String get editPinConfirmation => 'Edit this pin?';

	/// en: 'Latitude'
	String get latitude => 'Latitude';

	/// en: 'Longitude'
	String get longitude => 'Longitude';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Range'
	String get rangeLabel => 'Range';

	/// en: 'm'
	String get rangeUnit => 'm';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.cancel' => 'Cancel',
			'common.save' => 'Save',
			'common.saving' => 'Saving...',
			'home.title' => 'KoeMyaku',
			'home.emptyTitle' => 'No KoeMyaku yet',
			'home.emptyMessage' => 'Add pins on the map\nand leave voice memos',
			'home.errorLoading' => 'Failed to load',
			'home.retry' => 'Retry',
			'home.play' => 'Play',
			'home.share' => 'Share',
			'home.shareSubject' => 'Share KoeMyaku',
			'home.delete' => 'Delete',
			'home.deleteConfirmTitle' => 'Confirm Delete',
			'home.deleteConfirmMessage' => 'Are you sure you want to delete this KoeMyaku?',
			'home.deleteSuccess' => 'Deleted successfully',
			'home.deleteError' => 'Failed to delete',
			'home.editKoemyaku' => 'Edit KoeMyaku',
			'home.updateSuccess' => 'Updated successfully',
			'home.updateError' => 'Failed to update',
			'map.markerBottomSheet.addPinConfirmation' => 'Add a pin to this location?',
			'map.markerBottomSheet.editPinConfirmation' => 'Edit this pin?',
			'map.markerBottomSheet.latitude' => 'Latitude',
			'map.markerBottomSheet.longitude' => 'Longitude',
			'map.markerBottomSheet.delete' => 'Delete',
			'map.markerBottomSheet.save' => 'Save',
			'map.markerBottomSheet.close' => 'Close',
			'map.markerBottomSheet.rangeLabel' => 'Range',
			'map.markerBottomSheet.rangeUnit' => 'm',
			'map.saveKoemyaku' => 'Save Koemyaku',
			'map.title' => 'Title',
			'map.titleHint' => 'Enter title',
			'map.titleRequired' => 'Title is required',
			'map.message' => 'Message',
			'map.messageHint' => 'Enter message (optional)',
			'map.saveSuccess' => 'Saved successfully',
			'map.saveError' => 'Failed to save',
			'welcome.title' => 'KoeMyaku',
			'welcome.subtitle' => 'Memories of places, preserved in voice',
			'welcome.description' => 'Leave voice memos on the map\nand create your own voice map',
			'welcome.startButton' => 'Get Started',
			_ => null,
		};
	}
}
