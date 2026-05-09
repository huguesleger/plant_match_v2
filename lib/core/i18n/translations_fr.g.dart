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
	late final TranslationsFavoriteFr favorite = TranslationsFavoriteFr.internal(_root);
	late final TranslationsGetStartedFr getStarted = TranslationsGetStartedFr.internal(_root);
	late final TranslationsHistoryFr history = TranslationsHistoryFr.internal(_root);
	late final TranslationsLevelFr level = TranslationsLevelFr.internal(_root);
	late final TranslationsLevelAwardedFr levelAwarded = TranslationsLevelAwardedFr.internal(_root);
	late final TranslationsMessageFr message = TranslationsMessageFr.internal(_root);
	late final TranslationsOnboardingFr onboarding = TranslationsOnboardingFr.internal(_root);
	late final TranslationsPersonalInformationFr personalInformation = TranslationsPersonalInformationFr.internal(_root);
	late final TranslationsProfilFr profil = TranslationsProfilFr.internal(_root);
	late final TranslationsUserFr user = TranslationsUserFr.internal(_root);
}

// Path: favorite
class TranslationsFavoriteFr {
	TranslationsFavoriteFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsFavoriteScreenFr screen = TranslationsFavoriteScreenFr.internal(_root);
	late final TranslationsFavoriteEmptyFr empty = TranslationsFavoriteEmptyFr.internal(_root);
	late final TranslationsFavoriteCardFr card = TranslationsFavoriteCardFr.internal(_root);
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

// Path: history
class TranslationsHistoryFr {
	TranslationsHistoryFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsHistoryScreenFr screen = TranslationsHistoryScreenFr.internal(_root);
	late final TranslationsHistoryEmptyFr empty = TranslationsHistoryEmptyFr.internal(_root);
	late final TranslationsHistoryCardFr card = TranslationsHistoryCardFr.internal(_root);
	late final TranslationsHistoryFiltersFr filters = TranslationsHistoryFiltersFr.internal(_root);
	late final TranslationsHistoryStatusFr status = TranslationsHistoryStatusFr.internal(_root);
}

// Path: level
class TranslationsLevelFr {
	TranslationsLevelFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsLevelScreenFr screen = TranslationsLevelScreenFr.internal(_root);
	late final TranslationsLevelHeaderFr header = TranslationsLevelHeaderFr.internal(_root);
	late final TranslationsLevelCardsFr cards = TranslationsLevelCardsFr.internal(_root);
	late final TranslationsLevelProgressFr progress = TranslationsLevelProgressFr.internal(_root);
	late final TranslationsLevelDetailFr detail = TranslationsLevelDetailFr.internal(_root);
	late final TranslationsLevelLevelsFr levels = TranslationsLevelLevelsFr.internal(_root);
}

// Path: levelAwarded
class TranslationsLevelAwardedFr {
	TranslationsLevelAwardedFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsLevelAwardedSuccessFr success = TranslationsLevelAwardedSuccessFr.internal(_root);
}

// Path: message
class TranslationsMessageFr {
	TranslationsMessageFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsMessageScreenFr screen = TranslationsMessageScreenFr.internal(_root);
	late final TranslationsMessageEmptyFr empty = TranslationsMessageEmptyFr.internal(_root);
	late final TranslationsMessageErrorsFr errors = TranslationsMessageErrorsFr.internal(_root);
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

// Path: personalInformation
class TranslationsPersonalInformationFr {
	TranslationsPersonalInformationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsPersonalInformationScreenFr screen = TranslationsPersonalInformationScreenFr.internal(_root);
	late final TranslationsPersonalInformationDetailFr detail = TranslationsPersonalInformationDetailFr.internal(_root);
	late final TranslationsPersonalInformationWizardFr wizard = TranslationsPersonalInformationWizardFr.internal(_root);
	late final TranslationsPersonalInformationAvatarFr avatar = TranslationsPersonalInformationAvatarFr.internal(_root);
}

// Path: profil
class TranslationsProfilFr {
	TranslationsProfilFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsProfilNavigationFr navigation = TranslationsProfilNavigationFr.internal(_root);
	late final TranslationsProfilCardsFr cards = TranslationsProfilCardsFr.internal(_root);
}

// Path: user
class TranslationsUserFr {
	TranslationsUserFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsUserBioFr bio = TranslationsUserBioFr.internal(_root);
	late final TranslationsUserStatsFr stats = TranslationsUserStatsFr.internal(_root);
	late final TranslationsUserCardFr card = TranslationsUserCardFr.internal(_root);
	late final TranslationsUserRecentPlantsFr recent_plants = TranslationsUserRecentPlantsFr.internal(_root);
	late final TranslationsUserCatalogListFr catalog_list = TranslationsUserCatalogListFr.internal(_root);
	late final TranslationsUserDetailPlantFr detail_plant = TranslationsUserDetailPlantFr.internal(_root);
}

// Path: favorite.screen
class TranslationsFavoriteScreenFr {
	TranslationsFavoriteScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Mes Favoris'
	String get title => 'Mes Favoris';

	/// fr: 'Plantes ($count)'
	String plants_tab({required Object count}) => 'Plantes (${count})';

	/// fr: 'Profils ($count)'
	String users_tab({required Object count}) => 'Profils (${count})';
}

// Path: favorite.empty
class TranslationsFavoriteEmptyFr {
	TranslationsFavoriteEmptyFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsFavoriteEmptyPlantsFr plants = TranslationsFavoriteEmptyPlantsFr.internal(_root);
	late final TranslationsFavoriteEmptyUsersFr users = TranslationsFavoriteEmptyUsersFr.internal(_root);
}

// Path: favorite.card
class TranslationsFavoriteCardFr {
	TranslationsFavoriteCardFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Non disponible'
	String get not_available => 'Non disponible';

	/// fr: 'Plante $env'
	String env_prefix({required Object env}) => 'Plante ${env}';

	/// fr: 'Retirer'
	String get remove => 'Retirer';
}

// Path: history.screen
class TranslationsHistoryScreenFr {
	TranslationsHistoryScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Historique'
	String get title => 'Historique';

	/// fr: 'Erreur : $message'
	String error({required Object message}) => 'Erreur : ${message}';
}

// Path: history.empty
class TranslationsHistoryEmptyFr {
	TranslationsHistoryEmptyFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aucun échange ni donation dans l'historique'
	String get message => 'Aucun échange ni donation dans l\'historique';
}

// Path: history.card
class TranslationsHistoryCardFr {
	TranslationsHistoryCardFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Demande envoyée'
	String get request_sent => 'Demande envoyée';

	/// fr: 'Demande reçue'
	String get request_received => 'Demande reçue';

	/// fr: 'Échange'
	String get exchange => 'Échange';

	/// fr: 'Donation'
	String get donation => 'Donation';

	/// fr: 'Plante inconnue'
	String get unknown_plant => 'Plante inconnue';
}

// Path: history.filters
class TranslationsHistoryFiltersFr {
	TranslationsHistoryFiltersFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Tous'
	String get all => 'Tous';

	/// fr: 'Acceptés'
	String get accepted => 'Acceptés';

	/// fr: 'Terminés'
	String get completed => 'Terminés';

	/// fr: 'Refusés'
	String get rejected => 'Refusés';
}

// Path: history.status
class TranslationsHistoryStatusFr {
	TranslationsHistoryStatusFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Accepté'
	String get accepted => 'Accepté';

	/// fr: 'Terminé'
	String get completed => 'Terminé';

	/// fr: 'Refusé'
	String get rejected => 'Refusé';

	/// fr: 'En attente'
	String get pending => 'En attente';
}

// Path: level.screen
class TranslationsLevelScreenFr {
	TranslationsLevelScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Mes badges'
	String get title => 'Mes badges';

	/// fr: 'Mon niveau'
	String get my_level => 'Mon niveau';

	/// fr: 'Mes badges'
	String get my_badges => 'Mes badges';
}

// Path: level.header
class TranslationsLevelHeaderFr {
	TranslationsLevelHeaderFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Points'
	String get points => 'Points';

	/// fr: 'Niveau $level'
	String level({required Object level}) => 'Niveau ${level}';
}

// Path: level.cards
class TranslationsLevelCardsFr {
	TranslationsLevelCardsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsLevelCardsChallengesFr challenges = TranslationsLevelCardsChallengesFr.internal(_root);
	late final TranslationsLevelCardsGiftsFr gifts = TranslationsLevelCardsGiftsFr.internal(_root);

	/// fr: 'Découvrir'
	String get discover => 'Découvrir';
}

// Path: level.progress
class TranslationsLevelProgressFr {
	TranslationsLevelProgressFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Niveau '
	String get level_prefix => 'Niveau ';

	/// fr: 'pts'
	String get pts_suffix => 'pts';
}

// Path: level.detail
class TranslationsLevelDetailFr {
	TranslationsLevelDetailFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Niveau $level'
	String level_title({required Object level}) => 'Niveau ${level}';

	/// fr: 'Conditions : '
	String get conditions => 'Conditions : ';

	/// fr: 'Description : '
	String get description => 'Description : ';

	/// fr: 'Points nécessaires : '
	String get required_points => 'Points nécessaires : ';

	/// fr: 'Actions principales récompensées :'
	String get rewarded_actions_title => 'Actions principales récompensées :';

	/// fr: '(one) { $n point} (other) { $n points}'
	String points({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n,
		one: ' ${n} point',
		other: ' ${n} points',
	);
}

// Path: level.levels
class TranslationsLevelLevelsFr {
	TranslationsLevelLevelsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsLevelLevelsK1Fr k1 = TranslationsLevelLevelsK1Fr.internal(_root);
	late final TranslationsLevelLevelsK2Fr k2 = TranslationsLevelLevelsK2Fr.internal(_root);
	late final TranslationsLevelLevelsUnknownFr unknown = TranslationsLevelLevelsUnknownFr.internal(_root);
	late final TranslationsLevelLevelsNamesFr names = TranslationsLevelLevelsNamesFr.internal(_root);
}

// Path: levelAwarded.success
class TranslationsLevelAwardedSuccessFr {
	TranslationsLevelAwardedSuccessFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Bienvenue !'
	String get welcome_title => 'Bienvenue !';

	/// fr: 'Félicitations !'
	String get congrats_title => 'Félicitations !';

	/// fr: 'Nous sommes ravis de vous accueillir sur PlantMatch, vous avez remporté'
	String get welcome_desc => 'Nous sommes ravis de vous accueillir sur PlantMatch, vous avez remporté';

	/// fr: 'Votre aventure PlantMatch progresse, vous avez remporté'
	String get congrats_desc => 'Votre aventure PlantMatch progresse, vous avez remporté';

	/// fr: '(one) { $n point} (other) { $n points}'
	String points({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n,
		one: ' ${n} point',
		other: ' ${n} points',
	);

	/// fr: 'Voir ma progression'
	String get view_progression => 'Voir ma progression';
}

// Path: message.screen
class TranslationsMessageScreenFr {
	TranslationsMessageScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Mes messages'
	String get title => 'Mes messages';
}

// Path: message.empty
class TranslationsMessageEmptyFr {
	TranslationsMessageEmptyFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aucune conversation'
	String get title => 'Aucune conversation';

	/// fr: 'Commencez à discuter avec vos futurs partenaires d'échange !'
	String get subtitle => 'Commencez à discuter avec vos futurs partenaires d\'échange !';
}

// Path: message.errors
class TranslationsMessageErrorsFr {
	TranslationsMessageErrorsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Utilisateur non connecté'
	String get not_connected => 'Utilisateur non connecté';
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

// Path: personalInformation.screen
class TranslationsPersonalInformationScreenFr {
	TranslationsPersonalInformationScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Informations personnelles'
	String get title => 'Informations personnelles';
}

// Path: personalInformation.detail
class TranslationsPersonalInformationDetailFr {
	TranslationsPersonalInformationDetailFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Détail de mon profil'
	String get title => 'Détail de mon profil';

	/// fr: 'Pseudo d'affichage'
	String get pseudo => 'Pseudo d\'affichage';

	/// fr: 'Date d'anniversaire'
	String get birthday => 'Date d\'anniversaire';

	/// fr: 'Bio'
	String get bio => 'Bio';

	/// fr: 'Localisation'
	String get location => 'Localisation';

	/// fr: 'À renseigner'
	String get empty_field => 'À renseigner';

	/// fr: 'Modifier mon profil'
	String get edit_button => 'Modifier mon profil';
}

// Path: personalInformation.wizard
class TranslationsPersonalInformationWizardFr {
	TranslationsPersonalInformationWizardFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsPersonalInformationWizardPseudoFr pseudo = TranslationsPersonalInformationWizardPseudoFr.internal(_root);
	late final TranslationsPersonalInformationWizardBirthdayFr birthday = TranslationsPersonalInformationWizardBirthdayFr.internal(_root);
	late final TranslationsPersonalInformationWizardBioFr bio = TranslationsPersonalInformationWizardBioFr.internal(_root);
	late final TranslationsPersonalInformationWizardLocationFr location = TranslationsPersonalInformationWizardLocationFr.internal(_root);
	late final TranslationsPersonalInformationWizardCommonFr common = TranslationsPersonalInformationWizardCommonFr.internal(_root);
}

// Path: personalInformation.avatar
class TranslationsPersonalInformationAvatarFr {
	TranslationsPersonalInformationAvatarFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Photo de profil'
	String get sheet_title => 'Photo de profil';

	/// fr: 'Choisir depuis la galerie'
	String get gallery => 'Choisir depuis la galerie';

	/// fr: 'Prendre une photo'
	String get camera => 'Prendre une photo';

	/// fr: 'Choisir un avatar'
	String get choose_avatar => 'Choisir un avatar';

	/// fr: 'Aucune photo'
	String get none => 'Aucune photo';

	/// fr: 'Annuler'
	String get cancel => 'Annuler';

	/// fr: 'Valider'
	String get validate => 'Valider';

	/// fr: 'Sélectionnez un avatar'
	String get dialog_title => 'Sélectionnez un avatar';
}

// Path: profil.navigation
class TranslationsProfilNavigationFr {
	TranslationsProfilNavigationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Informations personnelles'
	String get personal_info => 'Informations personnelles';

	/// fr: 'Historique d’échanges'
	String get history => 'Historique d’échanges';

	/// fr: 'Paramètres de compte'
	String get settings => 'Paramètres de compte';

	/// fr: 'Aide'
	String get help => 'Aide';

	/// fr: 'Informations juridiques'
	String get legal => 'Informations juridiques';

	/// fr: 'À propos'
	String get about => 'À propos';

	/// fr: 'Se déconnecter'
	String get logout => 'Se déconnecter';
}

// Path: profil.cards
class TranslationsProfilCardsFr {
	TranslationsProfilCardsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsProfilCardsCatalogFr catalog = TranslationsProfilCardsCatalogFr.internal(_root);
	late final TranslationsProfilCardsFavoritesFr favorites = TranslationsProfilCardsFavoritesFr.internal(_root);
	late final TranslationsProfilCardsAwardsFr awards = TranslationsProfilCardsAwardsFr.internal(_root);
}

// Path: user.bio
class TranslationsUserBioFr {
	TranslationsUserBioFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Pas encore de description...'
	String get empty => 'Pas encore de description...';
}

// Path: user.stats
class TranslationsUserStatsFr {
	TranslationsUserStatsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: '(one) {plante} (other) {plantes}'
	String plants({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n,
		one: 'plante',
		other: 'plantes',
	);

	/// fr: 'plantMatch'
	String get matches => 'plantMatch';

	/// fr: 'niveau'
	String get level => 'niveau';

	/// fr: '(one) {er} (other) {ème}'
	String level_suffix({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n,
		one: 'er',
		other: 'ème',
	);
}

// Path: user.card
class TranslationsUserCardFr {
	TranslationsUserCardFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Ajouté le $date'
	String added_on({required Object date}) => 'Ajouté le ${date}';

	/// fr: 'Ajouté le'
	String get added_prefix => 'Ajouté le';
}

// Path: user.recent_plants
class TranslationsUserRecentPlantsFr {
	TranslationsUserRecentPlantsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Ajouts Récents'
	String get title => 'Ajouts Récents';
}

// Path: user.catalog_list
class TranslationsUserCatalogListFr {
	TranslationsUserCatalogListFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aucune plante'
	String get empty => 'Aucune plante';
}

// Path: user.detail_plant
class TranslationsUserDetailPlantFr {
	TranslationsUserDetailPlantFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Propriétaire'
	String get owner_placeholder => 'Propriétaire';

	/// fr: 'Envoyer un message'
	String get send_message => 'Envoyer un message';

	/// fr: 'plante $env'
	String env_prefix({required Object env}) => 'plante ${env}';

	/// fr: 'lumière'
	String get lighting => 'lumière';

	/// fr: 'arrosage'
	String get watering => 'arrosage';

	/// fr: 'entretien'
	String get maintenance => 'entretien';
}

// Path: favorite.empty.plants
class TranslationsFavoriteEmptyPlantsFr {
	TranslationsFavoriteEmptyPlantsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aucune plante en favoris'
	String get title => 'Aucune plante en favoris';

	/// fr: 'Appuyez sur ❤️ sur une plante pour l'ajouter'
	String get subtitle => 'Appuyez sur ❤️ sur une plante pour l\'ajouter';
}

// Path: favorite.empty.users
class TranslationsFavoriteEmptyUsersFr {
	TranslationsFavoriteEmptyUsersFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aucun profil en favoris'
	String get title => 'Aucun profil en favoris';

	/// fr: 'Appuyez sur ❤️ sur un profil pour l'ajouter'
	String get subtitle => 'Appuyez sur ❤️ sur un profil pour l\'ajouter';
}

// Path: level.cards.challenges
class TranslationsLevelCardsChallengesFr {
	TranslationsLevelCardsChallengesFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Défis et récompenses'
	String get title => 'Défis et récompenses';

	/// fr: 'Participer à des défis, gagner des récompenses'
	String get description => 'Participer à des défis, gagner des récompenses';
}

// Path: level.cards.gifts
class TranslationsLevelCardsGiftsFr {
	TranslationsLevelCardsGiftsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Choisir mes cadeaux'
	String get title => 'Choisir mes cadeaux';

	/// fr: 'Transformer vos points en cadeaux'
	String get description => 'Transformer vos points en cadeaux';
}

// Path: level.levels.k1
class TranslationsLevelLevelsK1Fr {
	TranslationsLevelLevelsK1Fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Inscription et ajout de la première plante dans le catalogue.'
	String get condition => 'Inscription et ajout de la première plante dans le catalogue.';

	/// fr: 'Bienvenue dans la communauté ! Tu viens de planter ta première graine.'
	String get description => 'Bienvenue dans la communauté ! Tu viens de planter ta première graine.';

	late final TranslationsLevelLevelsK1ActionsFr actions = TranslationsLevelLevelsK1ActionsFr.internal(_root);
}

// Path: level.levels.k2
class TranslationsLevelLevelsK2Fr {
	TranslationsLevelLevelsK2Fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Réaliser 4 échanges ou dons.'
	String get condition => 'Réaliser 4 échanges ou dons.';

	/// fr: 'Tu commences à échanger tes plantes et à partager ta passion !'
	String get description => 'Tu commences à échanger tes plantes et à partager ta passion !';

	late final TranslationsLevelLevelsK2ActionsFr actions = TranslationsLevelLevelsK2ActionsFr.internal(_root);
}

// Path: level.levels.unknown
class TranslationsLevelLevelsUnknownFr {
	TranslationsLevelLevelsUnknownFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Non défini'
	String get condition => 'Non défini';

	/// fr: 'Niveau inconnu.'
	String get description => 'Niveau inconnu.';
}

// Path: level.levels.names
class TranslationsLevelLevelsNamesFr {
	TranslationsLevelLevelsNamesFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Novice des plantes'
	String get k1 => 'Novice des plantes';

	/// fr: 'Amoureux des feuilles'
	String get k2 => 'Amoureux des feuilles';

	/// fr: 'Cultivateur actif'
	String get k3 => 'Cultivateur actif';

	/// fr: 'Jardinier confirmé'
	String get k4 => 'Jardinier confirmé';

	/// fr: 'Expert des plantes'
	String get k5 => 'Expert des plantes';

	/// fr: 'Maître du jardinage'
	String get k6 => 'Maître du jardinage';

	/// fr: 'Gardien de la nature'
	String get k7 => 'Gardien de la nature';
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

// Path: personalInformation.wizard.pseudo
class TranslationsPersonalInformationWizardPseudoFr {
	TranslationsPersonalInformationWizardPseudoFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Pseudo d'affichage'
	String get title => 'Pseudo d\'affichage';

	/// fr: 'Choisissez votre pseudo qui sera visible par les autres utilisateurs.'
	String get description => 'Choisissez votre pseudo qui sera visible par les autres utilisateurs.';

	/// fr: 'Entrez votre pseudo'
	String get hint => 'Entrez votre pseudo';

	/// fr: 'Pseudo'
	String get label => 'Pseudo';
}

// Path: personalInformation.wizard.birthday
class TranslationsPersonalInformationWizardBirthdayFr {
	TranslationsPersonalInformationWizardBirthdayFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Date d'anniversaire'
	String get title => 'Date d\'anniversaire';

	/// fr: 'Renseignez votre date de naissance pour recevoir des points le jour de votre anniversaire.'
	String get description => 'Renseignez votre date de naissance pour recevoir des points le jour de votre anniversaire.';

	/// fr: 'Entrez votre date de naissance'
	String get hint => 'Entrez votre date de naissance';

	/// fr: 'Date de naissance'
	String get label => 'Date de naissance';
}

// Path: personalInformation.wizard.bio
class TranslationsPersonalInformationWizardBioFr {
	TranslationsPersonalInformationWizardBioFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Bio'
	String get title => 'Bio';

	/// fr: 'Rédigez une courte description de vous.'
	String get description => 'Rédigez une courte description de vous.';

	/// fr: 'Ajoutez une description'
	String get hint => 'Ajoutez une description';

	/// fr: 'Bio'
	String get label => 'Bio';
}

// Path: personalInformation.wizard.location
class TranslationsPersonalInformationWizardLocationFr {
	TranslationsPersonalInformationWizardLocationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Localisation'
	String get title => 'Localisation';

	/// fr: 'Votre position sera utilisée pour vous proposer des profils proches de chez vous.'
	String get description => 'Votre position sera utilisée pour vous proposer des profils proches de chez vous.';
}

// Path: personalInformation.wizard.common
class TranslationsPersonalInformationWizardCommonFr {
	TranslationsPersonalInformationWizardCommonFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Ce champ est requis'
	String get required => 'Ce champ est requis';

	/// fr: 'Suivant'
	String get next => 'Suivant';

	/// fr: 'Me géolocaliser'
	String get geolocate => 'Me géolocaliser';
}

// Path: profil.cards.catalog
class TranslationsProfilCardsCatalogFr {
	TranslationsProfilCardsCatalogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Plantes & Boutures'
	String get title => 'Plantes & Boutures';

	/// fr: 'Mon catalogue de ce que j’ai à partager'
	String get description => 'Mon catalogue de ce que j’ai à partager';
}

// Path: profil.cards.favorites
class TranslationsProfilCardsFavoritesFr {
	TranslationsProfilCardsFavoritesFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Mes Favoris'
	String get title => 'Mes\nFavoris';

	/// fr: 'Mes plantes et profils préférés'
	String get description => 'Mes plantes et profils préférés';
}

// Path: profil.cards.awards
class TranslationsProfilCardsAwardsFr {
	TranslationsProfilCardsAwardsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Badges & Récompenses'
	String get title => 'Badges & Récompenses';

	/// fr: 'Mes badges et mon niveau'
	String get description => 'Mes badges et mon niveau';
}

// Path: level.levels.k1.actions
class TranslationsLevelLevelsK1ActionsFr {
	TranslationsLevelLevelsK1ActionsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Inscription'
	String get registration => 'Inscription';

	/// fr: 'Ajout d’une première plante'
	String get first_plant => 'Ajout d’une première plante';
}

// Path: level.levels.k2.actions
class TranslationsLevelLevelsK2ActionsFr {
	TranslationsLevelLevelsK2ActionsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: '1 échange ou dons réussi'
	String get first_exchange => '1 échange ou dons réussi';

	/// fr: 'Chaque échange ou dons supplémentaire'
	String get extra_exchange => 'Chaque échange ou dons supplémentaire';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'favorite.screen.title' => 'Mes Favoris',
			'favorite.screen.plants_tab' => ({required Object count}) => 'Plantes (${count})',
			'favorite.screen.users_tab' => ({required Object count}) => 'Profils (${count})',
			'favorite.empty.plants.title' => 'Aucune plante en favoris',
			'favorite.empty.plants.subtitle' => 'Appuyez sur ❤️ sur une plante pour l\'ajouter',
			'favorite.empty.users.title' => 'Aucun profil en favoris',
			'favorite.empty.users.subtitle' => 'Appuyez sur ❤️ sur un profil pour l\'ajouter',
			'favorite.card.not_available' => 'Non disponible',
			'favorite.card.env_prefix' => ({required Object env}) => 'Plante ${env}',
			'favorite.card.remove' => 'Retirer',
			'getStarted.title' => 'Échangez, adoptez et cultivez ensemble.',
			'getStarted.subtitle' => 'Rejoignez la communauté des amoureux des plantes près de chez vous.',
			'getStarted.button' => 'C\'est parti !',
			'history.screen.title' => 'Historique',
			'history.screen.error' => ({required Object message}) => 'Erreur : ${message}',
			'history.empty.message' => 'Aucun échange ni donation dans l\'historique',
			'history.card.request_sent' => 'Demande envoyée',
			'history.card.request_received' => 'Demande reçue',
			'history.card.exchange' => 'Échange',
			'history.card.donation' => 'Donation',
			'history.card.unknown_plant' => 'Plante inconnue',
			'history.filters.all' => 'Tous',
			'history.filters.accepted' => 'Acceptés',
			'history.filters.completed' => 'Terminés',
			'history.filters.rejected' => 'Refusés',
			'history.status.accepted' => 'Accepté',
			'history.status.completed' => 'Terminé',
			'history.status.rejected' => 'Refusé',
			'history.status.pending' => 'En attente',
			'level.screen.title' => 'Mes badges',
			'level.screen.my_level' => 'Mon niveau',
			'level.screen.my_badges' => 'Mes badges',
			'level.header.points' => 'Points',
			'level.header.level' => ({required Object level}) => 'Niveau ${level}',
			'level.cards.challenges.title' => 'Défis et récompenses',
			'level.cards.challenges.description' => 'Participer à des défis, gagner des récompenses',
			'level.cards.gifts.title' => 'Choisir mes cadeaux',
			'level.cards.gifts.description' => 'Transformer vos points en cadeaux',
			'level.cards.discover' => 'Découvrir',
			'level.progress.level_prefix' => 'Niveau ',
			'level.progress.pts_suffix' => 'pts',
			'level.detail.level_title' => ({required Object level}) => 'Niveau ${level}',
			'level.detail.conditions' => 'Conditions : ',
			'level.detail.description' => 'Description : ',
			'level.detail.required_points' => 'Points nécessaires : ',
			'level.detail.rewarded_actions_title' => 'Actions principales récompensées :',
			'level.detail.points' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n, one: ' ${n} point', other: ' ${n} points', ), 
			'level.levels.k1.condition' => 'Inscription et ajout de la première plante dans le catalogue.',
			'level.levels.k1.description' => 'Bienvenue dans la communauté ! Tu viens de planter ta première graine.',
			'level.levels.k1.actions.registration' => 'Inscription',
			'level.levels.k1.actions.first_plant' => 'Ajout d’une première plante',
			'level.levels.k2.condition' => 'Réaliser 4 échanges ou dons.',
			'level.levels.k2.description' => 'Tu commences à échanger tes plantes et à partager ta passion !',
			'level.levels.k2.actions.first_exchange' => '1 échange ou dons réussi',
			'level.levels.k2.actions.extra_exchange' => 'Chaque échange ou dons supplémentaire',
			'level.levels.unknown.condition' => 'Non défini',
			'level.levels.unknown.description' => 'Niveau inconnu.',
			'level.levels.names.k1' => 'Novice des plantes',
			'level.levels.names.k2' => 'Amoureux des feuilles',
			'level.levels.names.k3' => 'Cultivateur actif',
			'level.levels.names.k4' => 'Jardinier confirmé',
			'level.levels.names.k5' => 'Expert des plantes',
			'level.levels.names.k6' => 'Maître du jardinage',
			'level.levels.names.k7' => 'Gardien de la nature',
			'levelAwarded.success.welcome_title' => 'Bienvenue !',
			'levelAwarded.success.congrats_title' => 'Félicitations !',
			'levelAwarded.success.welcome_desc' => 'Nous sommes ravis de vous accueillir sur PlantMatch, vous avez remporté',
			'levelAwarded.success.congrats_desc' => 'Votre aventure PlantMatch progresse, vous avez remporté',
			'levelAwarded.success.points' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n, one: ' ${n} point', other: ' ${n} points', ), 
			'levelAwarded.success.view_progression' => 'Voir ma progression',
			'message.screen.title' => 'Mes messages',
			'message.empty.title' => 'Aucune conversation',
			'message.empty.subtitle' => 'Commencez à discuter avec vos futurs partenaires d\'échange !',
			'message.errors.not_connected' => 'Utilisateur non connecté',
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
			'personalInformation.screen.title' => 'Informations personnelles',
			'personalInformation.detail.title' => 'Détail de mon profil',
			'personalInformation.detail.pseudo' => 'Pseudo d\'affichage',
			'personalInformation.detail.birthday' => 'Date d\'anniversaire',
			'personalInformation.detail.bio' => 'Bio',
			'personalInformation.detail.location' => 'Localisation',
			'personalInformation.detail.empty_field' => 'À renseigner',
			'personalInformation.detail.edit_button' => 'Modifier mon profil',
			'personalInformation.wizard.pseudo.title' => 'Pseudo d\'affichage',
			'personalInformation.wizard.pseudo.description' => 'Choisissez votre pseudo qui sera visible par les autres utilisateurs.',
			'personalInformation.wizard.pseudo.hint' => 'Entrez votre pseudo',
			'personalInformation.wizard.pseudo.label' => 'Pseudo',
			'personalInformation.wizard.birthday.title' => 'Date d\'anniversaire',
			'personalInformation.wizard.birthday.description' => 'Renseignez votre date de naissance pour recevoir des points le jour de votre anniversaire.',
			'personalInformation.wizard.birthday.hint' => 'Entrez votre date de naissance',
			'personalInformation.wizard.birthday.label' => 'Date de naissance',
			'personalInformation.wizard.bio.title' => 'Bio',
			'personalInformation.wizard.bio.description' => 'Rédigez une courte description de vous.',
			'personalInformation.wizard.bio.hint' => 'Ajoutez une description',
			'personalInformation.wizard.bio.label' => 'Bio',
			'personalInformation.wizard.location.title' => 'Localisation',
			'personalInformation.wizard.location.description' => 'Votre position sera utilisée pour vous proposer des profils proches de chez vous.',
			'personalInformation.wizard.common.required' => 'Ce champ est requis',
			'personalInformation.wizard.common.next' => 'Suivant',
			'personalInformation.wizard.common.geolocate' => 'Me géolocaliser',
			'personalInformation.avatar.sheet_title' => 'Photo de profil',
			'personalInformation.avatar.gallery' => 'Choisir depuis la galerie',
			'personalInformation.avatar.camera' => 'Prendre une photo',
			'personalInformation.avatar.choose_avatar' => 'Choisir un avatar',
			'personalInformation.avatar.none' => 'Aucune photo',
			'personalInformation.avatar.cancel' => 'Annuler',
			'personalInformation.avatar.validate' => 'Valider',
			'personalInformation.avatar.dialog_title' => 'Sélectionnez un avatar',
			'profil.navigation.personal_info' => 'Informations personnelles',
			'profil.navigation.history' => 'Historique d’échanges',
			'profil.navigation.settings' => 'Paramètres de compte',
			'profil.navigation.help' => 'Aide',
			'profil.navigation.legal' => 'Informations juridiques',
			'profil.navigation.about' => 'À propos',
			'profil.navigation.logout' => 'Se déconnecter',
			'profil.cards.catalog.title' => 'Plantes & Boutures',
			'profil.cards.catalog.description' => 'Mon catalogue de ce que j’ai à partager',
			'profil.cards.favorites.title' => 'Mes\nFavoris',
			'profil.cards.favorites.description' => 'Mes plantes et profils préférés',
			'profil.cards.awards.title' => 'Badges & Récompenses',
			'profil.cards.awards.description' => 'Mes badges et mon niveau',
			'user.bio.empty' => 'Pas encore de description...',
			'user.stats.plants' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n, one: 'plante', other: 'plantes', ), 
			'user.stats.matches' => 'plantMatch',
			'user.stats.level' => 'niveau',
			'user.stats.level_suffix' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n, one: 'er', other: 'ème', ), 
			'user.card.added_on' => ({required Object date}) => 'Ajouté le ${date}',
			'user.card.added_prefix' => 'Ajouté le',
			'user.recent_plants.title' => 'Ajouts Récents',
			'user.catalog_list.empty' => 'Aucune plante',
			'user.detail_plant.owner_placeholder' => 'Propriétaire',
			'user.detail_plant.send_message' => 'Envoyer un message',
			'user.detail_plant.env_prefix' => ({required Object env}) => 'plante ${env}',
			'user.detail_plant.lighting' => 'lumière',
			'user.detail_plant.watering' => 'arrosage',
			'user.detail_plant.maintenance' => 'entretien',
			_ => null,
		};
	}
}
