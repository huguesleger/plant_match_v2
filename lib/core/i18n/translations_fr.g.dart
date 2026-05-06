///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsFr = Translations; // ignore: unused_element
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
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsGetStartedFr getStarted = TranslationsGetStartedFr.internal(_root);
	late final TranslationsOnboardingFr onboarding = TranslationsOnboardingFr.internal(_root);
}

// Path: getStarted
class TranslationsGetStartedFr {
	TranslationsGetStartedFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Échangez, adoptez et cultivez ensemble.'
	String get title => 'Échangez, adoptez et cultivez ensemble.';

	/// fr: 'Rejoignez la communauté des amoureux des plantes près de chez vous.'
	String get subtitle => 'Rejoignez la communauté des amoureux des plantes près de chez vous.';

	/// fr: 'C'est parti !'
	String get button => 'C\'est parti !';
}

// Path: onboarding
class TranslationsOnboardingFr {
	TranslationsOnboardingFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsOnboardingItemsFr items = TranslationsOnboardingItemsFr.internal(_root);

	/// fr: 'Passer'
	String get skip => 'Passer';

	/// fr: 'S'enregistrer'
	String get register => 'S\'enregistrer';

	/// fr: 'S'identifier'
	String get login => 'S\'identifier';
}

// Path: onboarding.items
class TranslationsOnboardingItemsFr {
	TranslationsOnboardingItemsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsOnboardingItemsCatalogFr catalog = TranslationsOnboardingItemsCatalogFr.internal(_root);
	late final TranslationsOnboardingItemsMapFr map = TranslationsOnboardingItemsMapFr.internal(_root);
	late final TranslationsOnboardingItemsChatFr chat = TranslationsOnboardingItemsChatFr.internal(_root);
	late final TranslationsOnboardingItemsAdviceFr advice = TranslationsOnboardingItemsAdviceFr.internal(_root);
}

// Path: onboarding.items.catalog
class TranslationsOnboardingItemsCatalogFr {
	TranslationsOnboardingItemsCatalogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Catalogue de Plantes Personnalisé'
	String get title => 'Catalogue de Plantes\nPersonnalisé';

	/// fr: 'Créez et gérez votre propre collection de plantes. Ajoutez des photos, des descriptions, et recevez des rappels pour l’entretien de vos plantes.'
	String get description => 'Créez et gérez votre propre collection de plantes. Ajoutez des photos, des descriptions, et recevez des rappels pour l’entretien de vos plantes.';
}

// Path: onboarding.items.map
class TranslationsOnboardingItemsMapFr {
	TranslationsOnboardingItemsMapFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Échange de Plantes et Boutures'
	String get title => 'Échange de Plantes\net Boutures';

	/// fr: 'Découvrez et échangez des plantes ou boutures avec d'autres passionnés près de chez vous. Utilisez la géolocalisation pour trouver facilement des échanges.'
	String get description => 'Découvrez et échangez des plantes ou boutures avec d\'autres passionnés près de chez vous. Utilisez la géolocalisation pour trouver facilement des échanges.';
}

// Path: onboarding.items.chat
class TranslationsOnboardingItemsChatFr {
	TranslationsOnboardingItemsChatFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Messagerie Intégrée'
	String get title => 'Messagerie\nIntégrée';

	/// fr: 'Communiquez facilement avec d'autres utilisateurs pour organiser des échanges de plantes, poser des questions, ou simplement partager des conseils.'
	String get description => 'Communiquez facilement avec d\'autres utilisateurs pour organiser des échanges de plantes, poser des questions, ou simplement partager des conseils.';
}

// Path: onboarding.items.advice
class TranslationsOnboardingItemsAdviceFr {
	TranslationsOnboardingItemsAdviceFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aide et Conseils Communautaires'
	String get title => 'Aide et Conseils\nCommunautaires';

	/// fr: 'Posez des questions et obtenez des conseils personnalisés de la part de la communauté pour mieux prendre soin de vos plantes ou résoudre des problèmes.'
	String get description => 'Posez des questions et obtenez des conseils personnalisés de la part de la communauté pour mieux prendre soin de vos plantes ou résoudre des problèmes.';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'getStarted.title' => 'Échangez, adoptez et cultivez ensemble.',
			'getStarted.subtitle' => 'Rejoignez la communauté des amoureux des plantes près de chez vous.',
			'getStarted.button' => 'C\'est parti !',
			'onboarding.items.catalog.title' => 'Catalogue de Plantes\nPersonnalisé',
			'onboarding.items.catalog.description' => 'Créez et gérez votre propre collection de plantes. Ajoutez des photos, des descriptions, et recevez des rappels pour l’entretien de vos plantes.',
			'onboarding.items.map.title' => 'Échange de Plantes\net Boutures',
			'onboarding.items.map.description' => 'Découvrez et échangez des plantes ou boutures avec d\'autres passionnés près de chez vous. Utilisez la géolocalisation pour trouver facilement des échanges.',
			'onboarding.items.chat.title' => 'Messagerie\nIntégrée',
			'onboarding.items.chat.description' => 'Communiquez facilement avec d\'autres utilisateurs pour organiser des échanges de plantes, poser des questions, ou simplement partager des conseils.',
			'onboarding.items.advice.title' => 'Aide et Conseils\nCommunautaires',
			'onboarding.items.advice.description' => 'Posez des questions et obtenez des conseils personnalisés de la part de la communauté pour mieux prendre soin de vos plantes ou résoudre des problèmes.',
			'onboarding.skip' => 'Passer',
			'onboarding.register' => 'S\'enregistrer',
			'onboarding.login' => 'S\'identifier',
			_ => null,
		};
	}
}
