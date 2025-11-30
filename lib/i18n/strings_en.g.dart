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
	late final TranslationsFinderEn finder = TranslationsFinderEn._(_root);
	late final TranslationsFinderWebEn finderWeb = TranslationsFinderWebEn._(_root);
	late final TranslationsShareEn share = TranslationsShareEn._(_root);
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

	/// en: 'Tap to add voice'
	String get editTitle => 'Tap to add voice';

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

// Path: finder
class TranslationsFinderEn {
	TranslationsFinderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Getting location...'
	String get initializing => 'Getting location...';

	/// en: 'Finding voice ($index/$total)'
	String findingVoice({required Object index, required Object total}) => 'Finding voice (${index}/${total})';

	/// en: 'away'
	String get distanceAway => 'away';

	/// en: 'Skip'
	String get skip => 'Skip';

	/// en: 'Skip to next'
	String get skipToNext => 'Skip to next';

	/// en: 'You've arrived!'
	String get arrived => 'You\'ve arrived!';

	/// en: 'All done!'
	String get allCompleted => 'All done!';

	/// en: 'You've listened to all voices'
	String get allCompletedMessage => 'You\'ve listened to all voices';

	/// en: 'Completed'
	String get completedTitle => 'Completed';

	/// en: 'You've listened to all KoeMyaku! Great job.'
	String get completedMessage => 'You\'ve listened to all KoeMyaku! Great job.';

	/// en: 'Finish'
	String get finish => 'Finish';

	/// en: 'An error occurred'
	String get error => 'An error occurred';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'No voice markers found'
	String get noVoiceMarkers => 'No voice markers found';
}

// Path: finderWeb
class TranslationsFinderWebEn {
	TranslationsFinderWebEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'KoeMyaku not found'
	String get notFound => 'KoeMyaku not found';

	/// en: 'Location and Compass Permission'
	String get permissionTitle => 'Location and Compass Permission';

	/// en: 'To use this feature, please allow access to your location and compass (orientation sensor).'
	String get permissionMessage => 'To use this feature, please allow access to your location and compass (orientation sensor).';

	/// en: 'If you're using iOS, please tap the button below to grant permission.'
	String get permissionNote => 'If you\'re using iOS, please tap the button below to grant permission.';

	/// en: 'Grant Permission'
	String get grantPermission => 'Grant Permission';

	/// en: 'Permission Denied'
	String get permissionDenied => 'Permission Denied';

	/// en: 'Access to location or compass was denied. Please allow it in your browser settings.'
	String get permissionDeniedMessage => 'Access to location or compass was denied. Please allow it in your browser settings.';

	/// en: 'Compass Not Supported'
	String get compassNotSupported => 'Compass Not Supported';

	/// en: 'Compass is not supported on this device or browser. We'll guide you using location only.'
	String get compassNotSupportedMessage => 'Compass is not supported on this device or browser. We\'ll guide you using location only.';

	/// en: 'Continue'
	String get continueAnyway => 'Continue';

	/// en: 'Back to Home'
	String get backToHome => 'Back to Home';
}

// Path: share
class TranslationsShareEn {
	TranslationsShareEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Share'
	String get title => 'Share';

	/// en: 'Copy Link'
	String get copyLink => 'Copy Link';

	/// en: 'Link copied'
	String get linkCopied => 'Link copied';

	/// en: 'Close'
	String get close => 'Close';
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
			'map.editTitle' => 'Tap to add voice',
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
			'finder.initializing' => 'Getting location...',
			'finder.findingVoice' => ({required Object index, required Object total}) => 'Finding voice (${index}/${total})',
			'finder.distanceAway' => 'away',
			'finder.skip' => 'Skip',
			'finder.skipToNext' => 'Skip to next',
			'finder.arrived' => 'You\'ve arrived!',
			'finder.allCompleted' => 'All done!',
			'finder.allCompletedMessage' => 'You\'ve listened to all voices',
			'finder.completedTitle' => 'Completed',
			'finder.completedMessage' => 'You\'ve listened to all KoeMyaku! Great job.',
			'finder.finish' => 'Finish',
			'finder.error' => 'An error occurred',
			'finder.close' => 'Close',
			'finder.noVoiceMarkers' => 'No voice markers found',
			'finderWeb.loading' => 'Loading...',
			'finderWeb.notFound' => 'KoeMyaku not found',
			'finderWeb.permissionTitle' => 'Location and Compass Permission',
			'finderWeb.permissionMessage' => 'To use this feature, please allow access to your location and compass (orientation sensor).',
			'finderWeb.permissionNote' => 'If you\'re using iOS, please tap the button below to grant permission.',
			'finderWeb.grantPermission' => 'Grant Permission',
			'finderWeb.permissionDenied' => 'Permission Denied',
			'finderWeb.permissionDeniedMessage' => 'Access to location or compass was denied. Please allow it in your browser settings.',
			'finderWeb.compassNotSupported' => 'Compass Not Supported',
			'finderWeb.compassNotSupportedMessage' => 'Compass is not supported on this device or browser. We\'ll guide you using location only.',
			'finderWeb.continueAnyway' => 'Continue',
			'finderWeb.backToHome' => 'Back to Home',
			'share.title' => 'Share',
			'share.copyLink' => 'Copy Link',
			'share.linkCopied' => 'Link copied',
			'share.close' => 'Close',
			_ => null,
		};
	}
}
