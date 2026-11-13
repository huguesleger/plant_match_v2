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
	late final TranslationsAccountSettingsFr accountSettings = TranslationsAccountSettingsFr.internal(_root);
	late final TranslationsAroundMeMapFr aroundMeMap = TranslationsAroundMeMapFr.internal(_root);
	late final TranslationsAuthFr auth = TranslationsAuthFr.internal(_root);
	late final TranslationsCatalogFr catalog = TranslationsCatalogFr.internal(_root);
	late final TranslationsChatPlantFr chatPlant = TranslationsChatPlantFr.internal(_root);
	late final TranslationsCommonFr common = TranslationsCommonFr.internal(_root);
	late final TranslationsExchangeFr exchange = TranslationsExchangeFr.internal(_root);
	late final TranslationsFavoriteFr favorite = TranslationsFavoriteFr.internal(_root);
	late final TranslationsGetStartedFr getStarted = TranslationsGetStartedFr.internal(_root);
	late final TranslationsHistoryFr history = TranslationsHistoryFr.internal(_root);
	late final TranslationsHomeFr home = TranslationsHomeFr.internal(_root);
	late final TranslationsLegalInformationFr legalInformation = TranslationsLegalInformationFr.internal(_root);
	late final TranslationsLevelFr level = TranslationsLevelFr.internal(_root);
	late final TranslationsLevelAwardedFr levelAwarded = TranslationsLevelAwardedFr.internal(_root);
	late final TranslationsMessageFr message = TranslationsMessageFr.internal(_root);
	late final TranslationsOnboardingFr onboarding = TranslationsOnboardingFr.internal(_root);
	late final TranslationsPersonalInformationFr personalInformation = TranslationsPersonalInformationFr.internal(_root);
	late final TranslationsProfilFr profil = TranslationsProfilFr.internal(_root);
	late final TranslationsRecentActivityFr recentActivity = TranslationsRecentActivityFr.internal(_root);
	late final TranslationsUserFr user = TranslationsUserFr.internal(_root);
	late final TranslationsWidgetsFr widgets = TranslationsWidgetsFr.internal(_root);
}

// Path: accountSettings
class TranslationsAccountSettingsFr {
	TranslationsAccountSettingsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAccountSettingsScreenFr screen = TranslationsAccountSettingsScreenFr.internal(_root);
	late final TranslationsAccountSettingsItemsFr items = TranslationsAccountSettingsItemsFr.internal(_root);
	late final TranslationsAccountSettingsChangePasswordFr change_password = TranslationsAccountSettingsChangePasswordFr.internal(_root);
	late final TranslationsAccountSettingsDeleteAccountFr delete_account = TranslationsAccountSettingsDeleteAccountFr.internal(_root);
	late final TranslationsAccountSettingsNotificationsFr notifications = TranslationsAccountSettingsNotificationsFr.internal(_root);
}

// Path: aroundMeMap
class TranslationsAroundMeMapFr {
	TranslationsAroundMeMapFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAroundMeMapHeaderFr header = TranslationsAroundMeMapHeaderFr.internal(_root);
	late final TranslationsAroundMeMapEmptyFr empty = TranslationsAroundMeMapEmptyFr.internal(_root);
	late final TranslationsAroundMeMapBottomSheetFr bottomSheet = TranslationsAroundMeMapBottomSheetFr.internal(_root);
	late final TranslationsAroundMeMapCardFr card = TranslationsAroundMeMapCardFr.internal(_root);
	late final TranslationsAroundMeMapCatalogUsersFr catalogUsers = TranslationsAroundMeMapCatalogUsersFr.internal(_root);
	late final TranslationsAroundMeMapStatusFr status = TranslationsAroundMeMapStatusFr.internal(_root);

	/// fr: '${value} km'
	String distance({required Object value}) => '${value} km';

	late final TranslationsAroundMeMapMapFr map = TranslationsAroundMeMapMapFr.internal(_root);
	late final TranslationsAroundMeMapRadiusFr radius = TranslationsAroundMeMapRadiusFr.internal(_root);
}

// Path: auth
class TranslationsAuthFr {
	TranslationsAuthFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthCommonFr common = TranslationsAuthCommonFr.internal(_root);
	late final TranslationsAuthSignInFr signIn = TranslationsAuthSignInFr.internal(_root);
	late final TranslationsAuthRegisterFr register = TranslationsAuthRegisterFr.internal(_root);
	late final TranslationsAuthForgotPasswordFr forgotPassword = TranslationsAuthForgotPasswordFr.internal(_root);
	late final TranslationsAuthEmailVerificationFr emailVerification = TranslationsAuthEmailVerificationFr.internal(_root);
	late final TranslationsAuthRegisterChoiceFr register_choice = TranslationsAuthRegisterChoiceFr.internal(_root);
}

// Path: catalog
class TranslationsCatalogFr {
	TranslationsCatalogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCatalogScreenFr screen = TranslationsCatalogScreenFr.internal(_root);
	late final TranslationsCatalogTabsFr tabs = TranslationsCatalogTabsFr.internal(_root);
	late final TranslationsCatalogEmptyFr empty = TranslationsCatalogEmptyFr.internal(_root);
	late final TranslationsCatalogCardFr card = TranslationsCatalogCardFr.internal(_root);
	late final TranslationsCatalogStatusFr status = TranslationsCatalogStatusFr.internal(_root);
	late final TranslationsCatalogDetailFr detail = TranslationsCatalogDetailFr.internal(_root);
	late final TranslationsCatalogEditFr edit = TranslationsCatalogEditFr.internal(_root);
	late final TranslationsCatalogWizardFr wizard = TranslationsCatalogWizardFr.internal(_root);
	late final TranslationsCatalogFamiliesFr families = TranslationsCatalogFamiliesFr.internal(_root);
	late final TranslationsCatalogEnumsFr enums = TranslationsCatalogEnumsFr.internal(_root);
	late final TranslationsCatalogSortFr sort = TranslationsCatalogSortFr.internal(_root);
}

// Path: chatPlant
class TranslationsChatPlantFr {
	TranslationsChatPlantFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsChatPlantScreenFr screen = TranslationsChatPlantScreenFr.internal(_root);
	late final TranslationsChatPlantViewFr view = TranslationsChatPlantViewFr.internal(_root);
	late final TranslationsChatPlantMenuFr menu = TranslationsChatPlantMenuFr.internal(_root);
	late final TranslationsChatPlantActionsFr actions = TranslationsChatPlantActionsFr.internal(_root);
	late final TranslationsChatPlantValidationFr validation = TranslationsChatPlantValidationFr.internal(_root);
	late final TranslationsChatPlantDisplayCodeFr display_code = TranslationsChatPlantDisplayCodeFr.internal(_root);
	late final TranslationsChatPlantPlantCardFr plant_card = TranslationsChatPlantPlantCardFr.internal(_root);
	late final TranslationsChatPlantInfoBarFr info_bar = TranslationsChatPlantInfoBarFr.internal(_root);
}

// Path: common
class TranslationsCommonFr {
	TranslationsCommonFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Utilisateur non connecté'
	String get notConnected => 'Utilisateur non connecté';
}

// Path: exchange
class TranslationsExchangeFr {
	TranslationsExchangeFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsExchangeScreenFr screen = TranslationsExchangeScreenFr.internal(_root);
	late final TranslationsExchangeConfirmationFr confirmation = TranslationsExchangeConfirmationFr.internal(_root);
	late final TranslationsExchangePickerFr picker = TranslationsExchangePickerFr.internal(_root);
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

// Path: home
class TranslationsHomeFr {
	TranslationsHomeFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsHomeHeaderFr header = TranslationsHomeHeaderFr.internal(_root);
	late final TranslationsHomeAroundMeFr around_me = TranslationsHomeAroundMeFr.internal(_root);
	late final TranslationsHomeCardFr card = TranslationsHomeCardFr.internal(_root);
	late final TranslationsHomeRecommendationFr recommendation = TranslationsHomeRecommendationFr.internal(_root);
	late final TranslationsHomeRecentActivityFr recent_activity = TranslationsHomeRecentActivityFr.internal(_root);
}

// Path: legalInformation
class TranslationsLegalInformationFr {
	TranslationsLegalInformationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsLegalInformationScreenFr screen = TranslationsLegalInformationScreenFr.internal(_root);
	late final TranslationsLegalInformationItemsFr items = TranslationsLegalInformationItemsFr.internal(_root);
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
	late final TranslationsLevelAwardedRewardsFr rewards = TranslationsLevelAwardedRewardsFr.internal(_root);
}

// Path: message
class TranslationsMessageFr {
	TranslationsMessageFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsMessageScreenFr screen = TranslationsMessageScreenFr.internal(_root);
	late final TranslationsMessageEmptyFr empty = TranslationsMessageEmptyFr.internal(_root);
}

// Path: onboarding
class TranslationsOnboardingFr {
	TranslationsOnboardingFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsOnboardingItemsFr items = TranslationsOnboardingItemsFr.internal(_root);

	/// fr: 'Passer'
	String get skip => 'Passer';

	/// fr: 'Créer un compte'
	String get register => 'Créer un compte';

	/// fr: 'Se connecter'
	String get login => 'Se connecter';
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
	late final TranslationsProfilPremiumFr premium = TranslationsProfilPremiumFr.internal(_root);
}

// Path: recentActivity
class TranslationsRecentActivityFr {
	TranslationsRecentActivityFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsRecentActivityScreenFr screen = TranslationsRecentActivityScreenFr.internal(_root);
	late final TranslationsRecentActivityEmptyFr empty = TranslationsRecentActivityEmptyFr.internal(_root);
	late final TranslationsRecentActivityTileFr tile = TranslationsRecentActivityTileFr.internal(_root);
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
	late final TranslationsUserFiltersFr filters = TranslationsUserFiltersFr.internal(_root);
}

// Path: widgets
class TranslationsWidgetsFr {
	TranslationsWidgetsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsWidgetsNavigationFr navigation = TranslationsWidgetsNavigationFr.internal(_root);
	late final TranslationsWidgetsErrorFr error = TranslationsWidgetsErrorFr.internal(_root);
	late final TranslationsWidgetsCommonFr common = TranslationsWidgetsCommonFr.internal(_root);
	late final TranslationsWidgetsDateFr date = TranslationsWidgetsDateFr.internal(_root);
	late final TranslationsWidgetsNotificationsFr notifications = TranslationsWidgetsNotificationsFr.internal(_root);
}

// Path: accountSettings.screen
class TranslationsAccountSettingsScreenFr {
	TranslationsAccountSettingsScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Paramètres de compte'
	String get title => 'Paramètres de compte';
}

// Path: accountSettings.items
class TranslationsAccountSettingsItemsFr {
	TranslationsAccountSettingsItemsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Modifier mon mot de passe'
	String get change_password => 'Modifier mon mot de passe';

	/// fr: 'Notifications'
	String get notifications => 'Notifications';

	/// fr: 'Paramètres de notification'
	String get notification_settings => 'Paramètres de notification';

	/// fr: 'Accès à ma position'
	String get location_access => 'Accès à ma position';
}

// Path: accountSettings.change_password
class TranslationsAccountSettingsChangePasswordFr {
	TranslationsAccountSettingsChangePasswordFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAccountSettingsChangePasswordCurrentPasswordFr current_password = TranslationsAccountSettingsChangePasswordCurrentPasswordFr.internal(_root);

	/// fr: 'Choisissez un nouveau mot de passe'
	String get new_password_section => 'Choisissez un nouveau mot de passe';

	/// fr: 'Nouveau mot de passe'
	String get new_password_label => 'Nouveau mot de passe';

	/// fr: 'Envoyer'
	String get submit => 'Envoyer';

	/// fr: 'Modification du mot de passe…'
	String get loading => 'Modification du mot de passe…';

	/// fr: 'Votre mot de passe a été modifié.'
	String get success => 'Votre mot de passe a été modifié.';

	/// fr: 'Le mot de passe actuel est incorrect.'
	String get wrong_current_password => 'Le mot de passe actuel est incorrect.';

	late final TranslationsAccountSettingsChangePasswordCreateFr create = TranslationsAccountSettingsChangePasswordCreateFr.internal(_root);

	/// fr: 'Votre compte est lié à un réseau social qui ne nous a pas transmis d'adresse e-mail. Vous ne pouvez donc pas créer de mot de passe : continuez à vous connecter avec ce réseau social.'
	String get unavailable => 'Votre compte est lié à un réseau social qui ne nous a pas transmis d\'adresse e-mail. Vous ne pouvez donc pas créer de mot de passe : continuez à vous connecter avec ce réseau social.';
}

// Path: accountSettings.delete_account
class TranslationsAccountSettingsDeleteAccountFr {
	TranslationsAccountSettingsDeleteAccountFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Supprimer mon compte'
	String get button => 'Supprimer mon compte';

	/// fr: 'Suppression impossible'
	String get error_title => 'Suppression impossible';

	/// fr: 'Suppression du compte…'
	String get loading => 'Suppression du compte…';

	late final TranslationsAccountSettingsDeleteAccountDialogFr dialog = TranslationsAccountSettingsDeleteAccountDialogFr.internal(_root);
}

// Path: accountSettings.notifications
class TranslationsAccountSettingsNotificationsFr {
	TranslationsAccountSettingsNotificationsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Activation des notifications…'
	String get enabling => 'Activation des notifications…';

	/// fr: 'Désactivation des notifications…'
	String get disabling => 'Désactivation des notifications…';

	late final TranslationsAccountSettingsNotificationsPermissionDialogFr permission_dialog = TranslationsAccountSettingsNotificationsPermissionDialogFr.internal(_root);
}

// Path: aroundMeMap.header
class TranslationsAroundMeMapHeaderFr {
	TranslationsAroundMeMapHeaderFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'A proximité'
	String get title => 'A proximité';

	/// fr: 'Trouvez des utilisateurs autour de vous pour partager, échanger ...'
	String get subtitle => 'Trouvez des utilisateurs autour de vous pour partager, échanger ...';
}

// Path: aroundMeMap.empty
class TranslationsAroundMeMapEmptyFr {
	TranslationsAroundMeMapEmptyFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Oups ! vous n'êtes pas localisé'
	String get title => 'Oups ! vous n\'êtes pas localisé';

	/// fr: 'Veuillez activer votre localisation pour voir les utilisateurs autour de vous'
	String get description => 'Veuillez activer votre localisation pour voir les utilisateurs autour de vous';

	/// fr: 'Me géolocaliser'
	String get button => 'Me géolocaliser';
}

// Path: aroundMeMap.bottomSheet
class TranslationsAroundMeMapBottomSheetFr {
	TranslationsAroundMeMapBottomSheetFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Plantes & Boutures'
	String get title => 'Plantes & Boutures';

	/// fr: 'Mon catalogue de ce que j’ai à partager'
	String get description => 'Mon catalogue de ce que j’ai à partager';

	/// fr: 'Voir le profil'
	String get viewProfile => 'Voir le profil';
}

// Path: aroundMeMap.card
class TranslationsAroundMeMapCardFr {
	TranslationsAroundMeMapCardFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'plante ${env}'
	String plantEnv({required Object env}) => 'plante ${env}';
}

// Path: aroundMeMap.catalogUsers
class TranslationsAroundMeMapCatalogUsersFr {
	TranslationsAroundMeMapCatalogUsersFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aucun catalogue disponible'
	String get empty => 'Aucun catalogue disponible';

	/// fr: '${name} n'a pas encore de catalogue.'
	String userNoCatalog({required Object name}) => '${name} n\'a pas encore de catalogue.';
}

// Path: aroundMeMap.status
class TranslationsAroundMeMapStatusFr {
	TranslationsAroundMeMapStatusFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'En ligne'
	String get online => 'En ligne';

	/// fr: 'Hors ligne'
	String get offline => 'Hors ligne';
}

// Path: aroundMeMap.map
class TranslationsAroundMeMapMapFr {
	TranslationsAroundMeMapMapFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aucune plante trouvée dans ce rayon'
	String get empty_title => 'Aucune plante trouvée dans ce rayon';

	/// fr: 'Élargissez le rayon de recherche pour découvrir plus de plantes autour de vous.'
	String get empty_widen => 'Élargissez le rayon de recherche pour découvrir plus de plantes autour de vous.';

	/// fr: 'Soyez le premier à publier une plante dans l'application !'
	String get empty_first => 'Soyez le premier à publier une plante dans l\'application !';

	/// fr: 'Élargir le rayon'
	String get empty_widen_btn => 'Élargir le rayon';

	/// fr: 'Compris'
	String get empty_close_btn => 'Compris';
}

// Path: aroundMeMap.radius
class TranslationsAroundMeMapRadiusFr {
	TranslationsAroundMeMapRadiusFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Rayon de recherche'
	String get title => 'Rayon de recherche';

	/// fr: 'Définissez la distance maximale pour découvrir des plantes autour de vous.'
	String get description => 'Définissez la distance maximale pour découvrir des plantes autour de vous.';

	/// fr: 'Dans un rayon de'
	String get within => 'Dans un rayon de';

	/// fr: 'Appliquer'
	String get apply => 'Appliquer';
}

// Path: auth.common
class TranslationsAuthCommonFr {
	TranslationsAuthCommonFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthCommonEmailFr email = TranslationsAuthCommonEmailFr.internal(_root);
	late final TranslationsAuthCommonPasswordFr password = TranslationsAuthCommonPasswordFr.internal(_root);
	late final TranslationsAuthCommonFullNameFr fullName = TranslationsAuthCommonFullNameFr.internal(_root);
	late final TranslationsAuthCommonFirstNameFr firstName = TranslationsAuthCommonFirstNameFr.internal(_root);
	late final TranslationsAuthCommonLastNameFr lastName = TranslationsAuthCommonLastNameFr.internal(_root);

	/// fr: 'Retour'
	String get back => 'Retour';

	/// fr: 'Confirmer'
	String get confirm => 'Confirmer';

	/// fr: 'Ok'
	String get ok => 'Ok';

	/// fr: 'Oups ! une erreur est survénue 🫤'
	String get error_title => 'Oups !\nune erreur est survénue 🫤';
}

// Path: auth.signIn
class TranslationsAuthSignInFr {
	TranslationsAuthSignInFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Hey! Bienvenue'
	String get title => 'Hey! Bienvenue';

	/// fr: 'Mot de passe oublié ?'
	String get forgotPassword => 'Mot de passe oublié ?';

	/// fr: 'Pas encore de compte ?'
	String get noAccount => 'Pas encore de compte ?';

	/// fr: 'Créer un compte'
	String get createAccount => 'Créer un compte';

	late final TranslationsAuthSignInSocialFr social = TranslationsAuthSignInSocialFr.internal(_root);

	/// fr: 'Se connecter'
	String get login => 'Se connecter';
}

// Path: auth.register
class TranslationsAuthRegisterFr {
	TranslationsAuthRegisterFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Créer un compte'
	String get title => 'Créer un compte';

	/// fr: 'Commencez !'
	String get welcome => 'Commencez !';

	/// fr: 'Il semblerait que vous soyez nouveau ici. Créons votre profil.'
	String get description => 'Il semblerait que vous soyez nouveau ici. Créons votre profil.';

	late final TranslationsAuthRegisterConfirmPasswordFr confirmPassword = TranslationsAuthRegisterConfirmPasswordFr.internal(_root);

	/// fr: 'Vous avez déjà un compte ?'
	String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

	/// fr: 'S'identifier'
	String get signIn => 'S\'identifier';

	late final TranslationsAuthRegisterPasswordRulesFr passwordRules = TranslationsAuthRegisterPasswordRulesFr.internal(_root);
	late final TranslationsAuthRegisterCguFr cgu = TranslationsAuthRegisterCguFr.internal(_root);
}

// Path: auth.forgotPassword
class TranslationsAuthForgotPasswordFr {
	TranslationsAuthForgotPasswordFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Mot de passe oublié ?'
	String get title => 'Mot de passe oublié ?';

	/// fr: 'Entrez votre e-mail pour réinitialiser le mot de passe'
	String get description => 'Entrez votre e-mail pour réinitialiser le mot de passe';

	/// fr: 'Un e-mail de réinitialisation a été envoyé sur ${email}'
	String emailSent({required Object email}) => 'Un e-mail de réinitialisation a été envoyé sur ${email}';

	/// fr: 'Envoyer'
	String get send => 'Envoyer';
}

// Path: auth.emailVerification
class TranslationsAuthEmailVerificationFr {
	TranslationsAuthEmailVerificationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Validez votre compte'
	String get title => 'Validez votre compte';

	/// fr: 'Un e-mail a été envoyé à votre adresse : '
	String get description => 'Un e-mail a été envoyé à votre adresse :\n';

	/// fr: ' Cliquez sur le lien pour vérifier votre e-mail avant de continuer.'
	String get instruction => '\nCliquez sur le lien pour vérifier votre e-mail avant de continuer.';

	/// fr: 'Un nouvel e-mail de vérification a été envoyé.'
	String get resendEmailSent => 'Un nouvel e-mail de vérification a été envoyé.';

	/// fr: 'Finalisation de votre inscription...'
	String get finalizing => 'Finalisation de votre inscription...';

	/// fr: 'Renvoyer l'e-mail'
	String get resendBtn => 'Renvoyer l\'e-mail';

	/// fr: 'Réessayez dans ${count} s'
	String retryLabel({required Object count}) => 'Réessayez dans ${count} s';
}

// Path: auth.register_choice
class TranslationsAuthRegisterChoiceFr {
	TranslationsAuthRegisterChoiceFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Comment souhaitez-vous créer votre compte ?'
	String get title => 'Comment souhaitez-vous créer votre compte ?';

	/// fr: 'Créer votre compte avec votre adresse e-mail ou continuez avec votre méthode préférée.'
	String get description => 'Créer votre compte avec votre adresse e-mail ou continuez avec votre méthode préférée.';

	/// fr: 'Continuer avec un e-mail'
	String get email => 'Continuer avec un e-mail';

	/// fr: 'Continuer avec Google'
	String get google => 'Continuer avec Google';

	/// fr: 'Continuer avec Facebook'
	String get facebook => 'Continuer avec Facebook';
}

// Path: catalog.screen
class TranslationsCatalogScreenFr {
	TranslationsCatalogScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Mes plantes'
	String get title => 'Mes plantes';

	/// fr: 'Mon catalogue de plantes à partager'
	String get subtitle => 'Mon catalogue de plantes à partager';

	/// fr: 'Ton catalogue est vide. Ajoute ta première plante pour commencer.'
	String get empty_message => 'Ton catalogue est vide. Ajoute ta première plante pour commencer.';
}

// Path: catalog.tabs
class TranslationsCatalogTabsFr {
	TranslationsCatalogTabsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Publié (${count})'
	String published({required Object count}) => 'Publié (${count})';

	/// fr: 'Brouillon (${count})'
	String draft({required Object count}) => 'Brouillon (${count})';

	/// fr: 'Archivé (${count})'
	String archived({required Object count}) => 'Archivé (${count})';
}

// Path: catalog.empty
class TranslationsCatalogEmptyFr {
	TranslationsCatalogEmptyFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aucune plante archivée'
	String get no_archived => 'Aucune plante archivée';

	/// fr: 'Aucun brouillon'
	String get no_draft => 'Aucun brouillon';

	/// fr: 'Aucune plante publiée'
	String get no_published => 'Aucune plante publiée';

	/// fr: 'Aucune description'
	String get no_description => 'Aucune description';
}

// Path: catalog.card
class TranslationsCatalogCardFr {
	TranslationsCatalogCardFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Plantes & boutures'
	String get title => 'Plantes & boutures';

	/// fr: 'Mon catalogue de ce que j’ai à partager'
	String get subtitle => 'Mon catalogue de ce que j’ai à partager';
}

// Path: catalog.status
class TranslationsCatalogStatusFr {
	TranslationsCatalogStatusFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Brouillon'
	String get draft => 'Brouillon';

	/// fr: 'Publié'
	String get published => 'Publié';

	/// fr: 'Archivé'
	String get archived => 'Archivé';
}

// Path: catalog.detail
class TranslationsCatalogDetailFr {
	TranslationsCatalogDetailFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'plante ${env}'
	String plant_env({required Object env}) => 'plante ${env}';

	/// fr: 'Description'
	String get description => 'Description';

	/// fr: 'lumière'
	String get lighting => 'lumière';

	/// fr: 'arrosage'
	String get watering => 'arrosage';

	/// fr: 'entretien'
	String get maintenance => 'entretien';

	/// fr: 'Supprimer'
	String get delete => 'Supprimer';

	/// fr: 'Modifier'
	String get edit => 'Modifier';

	late final TranslationsCatalogDetailDeleteDialogFr delete_dialog = TranslationsCatalogDetailDeleteDialogFr.internal(_root);

	/// fr: 'La suppression a échoué. Réessaie plus tard.'
	String get delete_error => 'La suppression a échoué. Réessaie plus tard.';
}

// Path: catalog.edit
class TranslationsCatalogEditFr {
	TranslationsCatalogEditFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Modifier ma plante'
	String get title => 'Modifier ma plante';

	/// fr: 'Modifier ${name}'
	String modifier_with_name({required Object name}) => 'Modifier ${name}';

	/// fr: 'Enregistrer les modifications'
	String get save => 'Enregistrer les modifications';

	/// fr: 'Erreur upload: ${error}'
	String upload_error({required Object error}) => 'Erreur upload: ${error}';

	late final TranslationsCatalogEditNameFr name = TranslationsCatalogEditNameFr.internal(_root);
	late final TranslationsCatalogEditDescriptionFr description = TranslationsCatalogEditDescriptionFr.internal(_root);
	late final TranslationsCatalogEditFamilyFr family = TranslationsCatalogEditFamilyFr.internal(_root);
	late final TranslationsCatalogEditOfferTypeFr offer_type = TranslationsCatalogEditOfferTypeFr.internal(_root);
	late final TranslationsCatalogEditMaintenanceFr maintenance = TranslationsCatalogEditMaintenanceFr.internal(_root);
	late final TranslationsCatalogEditLightingFr lighting = TranslationsCatalogEditLightingFr.internal(_root);

	/// fr: 'Publier la plante'
	String get publish_label => 'Publier la plante';

	late final TranslationsCatalogEditWateringFr watering = TranslationsCatalogEditWateringFr.internal(_root);
	late final TranslationsCatalogEditEnvironmentFr environment = TranslationsCatalogEditEnvironmentFr.internal(_root);
	late final TranslationsCatalogEditImageFr image = TranslationsCatalogEditImageFr.internal(_root);
}

// Path: catalog.wizard
class TranslationsCatalogWizardFr {
	TranslationsCatalogWizardFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Ajouter une plante'
	String get title => 'Ajouter une plante';

	/// fr: 'Erreur lors de la sélection d’image.'
	String get error_image => 'Erreur lors de la sélection d’image.';

	/// fr: 'Sélectionner des images'
	String get select_images => 'Sélectionner des images';

	/// fr: 'Image ${index}'
	String image_count({required Object index}) => 'Image ${index}';

	/// fr: 'Ce champ est requis'
	String get required_field => 'Ce champ est requis';

	/// fr: 'Publier la plante'
	String get publish_label => 'Publier la plante';

	/// fr: 'Terminer'
	String get finish => 'Terminer';

	/// fr: 'Suivant'
	String get next => 'Suivant';

	late final TranslationsCatalogWizardQuitDialogFr quit_dialog = TranslationsCatalogWizardQuitDialogFr.internal(_root);
	late final TranslationsCatalogWizardStepsFr steps = TranslationsCatalogWizardStepsFr.internal(_root);
}

// Path: catalog.families
class TranslationsCatalogFamiliesFr {
	TranslationsCatalogFamiliesFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Tropicale'
	String get tropical => 'Tropicale';

	/// fr: 'Succulente'
	String get succulent => 'Succulente';

	/// fr: 'Aquatique'
	String get aquatic => 'Aquatique';

	/// fr: 'Grimpante'
	String get climbing => 'Grimpante';

	/// fr: 'Bonsaï'
	String get bonsai => 'Bonsaï';

	/// fr: 'Fleurie'
	String get flower => 'Fleurie';

	/// fr: 'Aromatique'
	String get aromatic => 'Aromatique';

	/// fr: 'Médicinale'
	String get medical => 'Médicinale';

	/// fr: 'Carnivore'
	String get carnivorous => 'Carnivore';
}

// Path: catalog.enums
class TranslationsCatalogEnumsFr {
	TranslationsCatalogEnumsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCatalogEnumsLightingFr lighting = TranslationsCatalogEnumsLightingFr.internal(_root);
	late final TranslationsCatalogEnumsEnvironmentFr environment = TranslationsCatalogEnumsEnvironmentFr.internal(_root);
	late final TranslationsCatalogEnumsMaintenanceFr maintenance = TranslationsCatalogEnumsMaintenanceFr.internal(_root);
	late final TranslationsCatalogEnumsWateringFr watering = TranslationsCatalogEnumsWateringFr.internal(_root);
	late final TranslationsCatalogEnumsOfferTypeFr offer_type = TranslationsCatalogEnumsOfferTypeFr.internal(_root);
}

// Path: catalog.sort
class TranslationsCatalogSortFr {
	TranslationsCatalogSortFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Trier par'
	String get title => 'Trier par';

	/// fr: 'Plus récent'
	String get newest => 'Plus récent';

	/// fr: 'Nom de la plante : A à Z'
	String get nameAsc => 'Nom de la plante : A à Z';

	/// fr: 'Nom de la plante : Z à A'
	String get nameDesc => 'Nom de la plante : Z à A';

	/// fr: 'Appliquer'
	String get btn => 'Appliquer';
}

// Path: chatPlant.screen
class TranslationsChatPlantScreenFr {
	TranslationsChatPlantScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Cette plante n'est plus disponible.'
	String get plant_unavailable => 'Cette plante n\'est plus disponible.';
}

// Path: chatPlant.view
class TranslationsChatPlantViewFr {
	TranslationsChatPlantViewFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aucun message pour le moment. Démarrez la conversation.'
	String get empty_messages => 'Aucun message pour le moment.\nDémarrez la conversation.';

	/// fr: 'Vous avez bloqué cet utilisateur'
	String get blocked_user_banner => 'Vous avez bloqué cet utilisateur';

	/// fr: 'Vous ne pouvez plus écrire à cet utilisateur'
	String get blocked_by_other_banner => 'Vous ne pouvez plus écrire à cet utilisateur';

	/// fr: 'Débloquer'
	String get unblock_btn => 'Débloquer';

	late final TranslationsChatPlantViewUnblockDialogFr unblock_dialog = TranslationsChatPlantViewUnblockDialogFr.internal(_root);
	late final TranslationsChatPlantViewStatusFr status = TranslationsChatPlantViewStatusFr.internal(_root);

	/// fr: 'Écrire un message…'
	String get input_hint => 'Écrire un message…';
}

// Path: chatPlant.menu
class TranslationsChatPlantMenuFr {
	TranslationsChatPlantMenuFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Voir le profil'
	String get see_profile => 'Voir le profil';

	/// fr: 'Signaler'
	String get report => 'Signaler';

	/// fr: 'Débloquer'
	String get unblock => 'Débloquer';

	/// fr: 'Bloquer'
	String get block => 'Bloquer';

	/// fr: 'Effacer la conversation'
	String get clear_chat => 'Effacer la conversation';

	/// fr: 'Supprimer'
	String get delete => 'Supprimer';

	late final TranslationsChatPlantMenuDeleteDialogFr delete_dialog = TranslationsChatPlantMenuDeleteDialogFr.internal(_root);
	late final TranslationsChatPlantMenuReportDialogFr report_dialog = TranslationsChatPlantMenuReportDialogFr.internal(_root);
	late final TranslationsChatPlantMenuBlockDialogFr block_dialog = TranslationsChatPlantMenuBlockDialogFr.internal(_root);
}

// Path: chatPlant.actions
class TranslationsChatPlantActionsFr {
	TranslationsChatPlantActionsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Accepter'
	String get accept => 'Accepter';

	/// fr: 'Refuser'
	String get refuse => 'Refuser';

	/// fr: 'Annuler'
	String get cancel => 'Annuler';

	/// fr: 'Confirmer'
	String get confirm => 'Confirmer';

	/// fr: 'Marquer $label comme terminée'
	String complete_label({required Object label}) => 'Marquer ${label} comme terminée';

	/// fr: 'Proposer un échange'
	String get propose_exchange_btn => 'Proposer un échange';

	late final TranslationsChatPlantActionsLabelsFr labels = TranslationsChatPlantActionsLabelsFr.internal(_root);
}

// Path: chatPlant.validation
class TranslationsChatPlantValidationFr {
	TranslationsChatPlantValidationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Confirmation de réception'
	String get title => 'Confirmation de réception';

	/// fr: 'Saisissez le code à 6 chiffres donné par le propriétaire.'
	String get description => 'Saisissez le code à 6 chiffres donné par le propriétaire.';

	/// fr: '000000'
	String get hint => '000000';

	/// fr: 'Confirmer la réception'
	String get confirm_btn => 'Confirmer la réception';
}

// Path: chatPlant.display_code
class TranslationsChatPlantDisplayCodeFr {
	TranslationsChatPlantDisplayCodeFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'L'échange est prêt !'
	String get ready_title => 'L\'échange est prêt !';

	/// fr: 'Générez le code une fois que vous êtes avec la personne.'
	String get ready_subtitle => 'Générez le code une fois que vous êtes avec la personne.';

	/// fr: 'Générer le code de remise'
	String get generate_btn => 'Générer le code de remise';

	/// fr: 'Code de confirmation'
	String get code_title => 'Code de confirmation';

	/// fr: 'Montrez ce code au receveur pour finaliser l'échange.'
	String get code_subtitle => 'Montrez ce code au receveur pour finaliser l\'échange.';

	/// fr: 'Générer un nouveau code'
	String get regenerate_btn => 'Générer un nouveau code';
}

// Path: chatPlant.plant_card
class TranslationsChatPlantPlantCardFr {
	TranslationsChatPlantPlantCardFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Plante proposée'
	String get proposed_plant => 'Plante proposée';

	/// fr: 'Proposition d'échange'
	String get exchange_proposal => 'Proposition d\'échange';

	/// fr: 'Voir le détail'
	String get view_detail => 'Voir le détail';

	/// fr: 'Impossible de charger les détails'
	String get error_loading => 'Impossible de charger les détails';
}

// Path: chatPlant.info_bar
class TranslationsChatPlantInfoBarFr {
	TranslationsChatPlantInfoBarFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsChatPlantInfoBarExchangeFr exchange = TranslationsChatPlantInfoBarExchangeFr.internal(_root);
	late final TranslationsChatPlantInfoBarDonationFr donation = TranslationsChatPlantInfoBarDonationFr.internal(_root);
}

// Path: exchange.screen
class TranslationsExchangeScreenFr {
	TranslationsExchangeScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Chargement...'
	String get loading => 'Chargement...';

	/// fr: 'Choisir une plante à échanger'
	String get picking_title => 'Choisir une plante à échanger';

	/// fr: 'Confirmer l'échange'
	String get confirm_title => 'Confirmer l\'échange';

	/// fr: 'Succès'
	String get success_title => 'Succès';

	/// fr: 'Échange proposé avec succès !'
	String get success_message => 'Échange proposé avec succès !';

	/// fr: 'Erreur'
	String get error_title => 'Erreur';
}

// Path: exchange.confirmation
class TranslationsExchangeConfirmationFr {
	TranslationsExchangeConfirmationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Tu proposes cette plante'
	String get offered_plant_title => 'Tu proposes cette plante';

	/// fr: 'Contre sa plante'
	String get target_plant_title => 'Contre sa plante';

	/// fr: 'Confirmer l'échange'
	String get confirm_btn => 'Confirmer l\'échange';

	/// fr: 'Choisir une autre plante'
	String get change_plant_btn => 'Choisir une autre plante';
}

// Path: exchange.picker
class TranslationsExchangePickerFr {
	TranslationsExchangePickerFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Tu n'as pas encore de plantes à échanger'
	String get no_plants => 'Tu n\'as pas encore de plantes à échanger';

	/// fr: 'Ajoute une plante proposée à l'échange pour pouvoir la proposer en retour.'
	String get no_plants_description => 'Ajoute une plante proposée à l\'échange pour pouvoir la proposer en retour.';

	/// fr: 'Ajouter une plante'
	String get add_plant => 'Ajouter une plante';

	/// fr: 'Sélectionne la plante que tu veux proposer en échange.'
	String get subtitle => 'Sélectionne la plante que tu veux proposer en échange.';
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

// Path: home.header
class TranslationsHomeHeaderFr {
	TranslationsHomeHeaderFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Hello, ${name}'
	String greeting({required Object name}) => 'Hello, ${name}';

	/// fr: 'Prêt à échanger ou donner de nouvelles plantes ?'
	String get subtitle => 'Prêt à échanger ou donner\nde nouvelles plantes ?';
}

// Path: home.around_me
class TranslationsHomeAroundMeFr {
	TranslationsHomeAroundMeFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Autour de toi'
	String get title => 'Autour de toi';

	/// fr: 'Voir sur la carte'
	String get see_on_map => 'Voir sur la carte';

	/// fr: 'Activez la géolocalisation pour voir les plantes autour de vous'
	String get no_location => 'Activez la géolocalisation pour voir les plantes autour de vous';

	/// fr: 'Aucune plante trouvée à proximité'
	String get empty => 'Aucune plante trouvée à proximité';
}

// Path: home.card
class TranslationsHomeCardFr {
	TranslationsHomeCardFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Échange'
	String get exchange => 'Échange';

	/// fr: 'Donation'
	String get donation => 'Donation';

	/// fr: '${distance} km • ${name}'
	String distance_owner({required Object distance, required Object name}) => '${distance} km • ${name}';
}

// Path: home.recommendation
class TranslationsHomeRecommendationFr {
	TranslationsHomeRecommendationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Tes suggestions personnalisées'
	String get title => 'Tes suggestions personnalisées';

	/// fr: 'Ajuster mes préférences'
	String get adjust_preferences => 'Ajuster mes préférences';

	/// fr: 'Aucune plante ne correspond à tes préférences actuelles.'
	String get empty => 'Aucune plante ne correspond à tes préférences actuelles.';

	/// fr: 'Ajuster les filtres'
	String get adjust_filters => 'Ajuster les filtres';

	/// fr: 'Trouve ta plante idéale'
	String get banner_title => 'Trouve ta plante idéale';

	/// fr: 'Réponds à quelques questions et nous te suggérons des plantes !'
	String get banner_subtitle => 'Réponds à quelques questions et nous te suggérons des plantes !';
}

// Path: home.recent_activity
class TranslationsHomeRecentActivityFr {
	TranslationsHomeRecentActivityFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Activité récente'
	String get title => 'Activité récente';

	/// fr: 'Voir tout'
	String get see_all => 'Voir tout';

	/// fr: 'Aucune activité récente'
	String get empty => 'Aucune activité récente';
}

// Path: legalInformation.screen
class TranslationsLegalInformationScreenFr {
	TranslationsLegalInformationScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Informations juridiques'
	String get title => 'Informations juridiques';
}

// Path: legalInformation.items
class TranslationsLegalInformationItemsFr {
	TranslationsLegalInformationItemsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Politique de confidentialité'
	String get privacy_policy => 'Politique de confidentialité';

	/// fr: 'Conditions d'utilisation'
	String get terms => 'Conditions d\'utilisation';

	/// fr: 'Mentions légales'
	String get legal_notice => 'Mentions légales';
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

	/// fr: 'Dons & Échanges'
	String get points => 'Dons & Échanges';

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

	/// fr: 'Niveau max'
	String get max_level => 'Niveau max';

	/// fr: ' dons/échanges'
	String get pts_suffix => ' dons/échanges';
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

	/// fr: 'Dons/Échanges requis : '
	String get required_points => 'Dons/Échanges requis : ';

	/// fr: 'Récompense du palier :'
	String get rewarded_actions_title => 'Récompense du palier :';

	/// fr: '(one) { $n don ou échange} (other) { $n dons ou échanges}'
	String points({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n,
		one: ' ${n} don ou échange',
		other: ' ${n} dons ou échanges',
	);

	/// fr: '(one) {+$n feuille bonus} (other) {+$n feuilles bonus}'
	String bonus_leaves({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n,
		one: '+${n} feuille bonus',
		other: '+${n} feuilles bonus',
	);

	/// fr: 'Pack de bienvenue (5 feuilles)'
	String get welcome_pack => 'Pack de bienvenue (5 feuilles)';

	/// fr: 'Contacts illimités, sans dépenser de feuilles'
	String get unlimited_contacts => 'Contacts illimités, sans dépenser de feuilles';
}

// Path: level.levels
class TranslationsLevelLevelsFr {
	TranslationsLevelLevelsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsLevelLevelsK1Fr k1 = TranslationsLevelLevelsK1Fr.internal(_root);
	late final TranslationsLevelLevelsK2Fr k2 = TranslationsLevelLevelsK2Fr.internal(_root);
	late final TranslationsLevelLevelsK3Fr k3 = TranslationsLevelLevelsK3Fr.internal(_root);
	late final TranslationsLevelLevelsK4Fr k4 = TranslationsLevelLevelsK4Fr.internal(_root);
	late final TranslationsLevelLevelsK5Fr k5 = TranslationsLevelLevelsK5Fr.internal(_root);
	late final TranslationsLevelLevelsK6Fr k6 = TranslationsLevelLevelsK6Fr.internal(_root);
	late final TranslationsLevelLevelsK7Fr k7 = TranslationsLevelLevelsK7Fr.internal(_root);
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

// Path: levelAwarded.rewards
class TranslationsLevelAwardedRewardsFr {
	TranslationsLevelAwardedRewardsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Félicitations !'
	String get default_title => 'Félicitations !';

	/// fr: 'Vous venez d'obtenir des feuilles bonus pour vos interactions.'
	String get default_description => 'Vous venez d\'obtenir des feuilles bonus pour vos interactions.';

	/// fr: 'Plante donnée !'
	String get plant_given => 'Plante donnée !';

	/// fr: 'Merci d'avoir fait vivre la communauté. Voici vos feuilles pour continuer vos adoptions.'
	String get plant_given_description => 'Merci d\'avoir fait vivre la communauté. Voici vos feuilles pour continuer vos adoptions.';

	/// fr: 'Code de parrainage validé !'
	String get referral => 'Code de parrainage validé !';

	/// fr: 'Niveau $level atteint !'
	String level_up_title({required Object level}) => 'Niveau ${level} atteint !';

	/// fr: 'Vous êtes maintenant $name. Voici vos feuilles bonus pour continuer vos adoptions.'
	String level_up_description({required Object name}) => 'Vous êtes maintenant ${name}. Voici vos feuilles bonus pour continuer vos adoptions.';

	/// fr: '(one) {+$n feuille} (other) {+$n feuilles}'
	String leaves({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n,
		one: '+${n} feuille',
		other: '+${n} feuilles',
	);
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

	late final TranslationsPersonalInformationDetailClearFr clear = TranslationsPersonalInformationDetailClearFr.internal(_root);
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
	late final TranslationsPersonalInformationWizardReferralFr referral = TranslationsPersonalInformationWizardReferralFr.internal(_root);
	late final TranslationsPersonalInformationWizardLeaveFr leave = TranslationsPersonalInformationWizardLeaveFr.internal(_root);
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

	late final TranslationsProfilNavigationNavigationTitleFr navigation_title = TranslationsProfilNavigationNavigationTitleFr.internal(_root);
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

// Path: profil.premium
class TranslationsProfilPremiumFr {
	TranslationsProfilPremiumFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'PlantMatch Premium'
	String get title => 'PlantMatch Premium';

	/// fr: 'Profiter des avantages premium avec des fonctionnalités exclusives.'
	String get description => 'Profiter des avantages premium avec des fonctionnalités exclusives.';

	/// fr: 'Découvrir'
	String get btn => 'Découvrir';
}

// Path: recentActivity.screen
class TranslationsRecentActivityScreenFr {
	TranslationsRecentActivityScreenFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Activité récente'
	String get title => 'Activité récente';
}

// Path: recentActivity.empty
class TranslationsRecentActivityEmptyFr {
	TranslationsRecentActivityEmptyFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aucune activité récente'
	String get message => 'Aucune activité récente';
}

// Path: recentActivity.tile
class TranslationsRecentActivityTileFr {
	TranslationsRecentActivityTileFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: ' a ajouté une plante'
	String get added_plant => ' a ajouté une plante';

	/// fr: '${count} min'
	String minutes({required Object count}) => '${count} min';

	/// fr: '${count} h'
	String hours({required Object count}) => '${count} h';

	/// fr: '${count} j'
	String days({required Object count}) => '${count} j';
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

	/// fr: 'Description'
	String get description_title => 'Description';

	/// fr: 'Les informations clés'
	String get key_info_title => 'Les informations clés';

	late final TranslationsUserDetailPlantNoLeavesFr no_leaves = TranslationsUserDetailPlantNoLeavesFr.internal(_root);
	late final TranslationsUserDetailPlantShareFr share = TranslationsUserDetailPlantShareFr.internal(_root);
}

// Path: user.filters
class TranslationsUserFiltersFr {
	TranslationsUserFiltersFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Tous'
	String get all => 'Tous';

	/// fr: 'Donations'
	String get donation => 'Donations';

	/// fr: 'Échanges'
	String get exchange => 'Échanges';

	/// fr: 'Extérieur'
	String get outdoor => 'Extérieur';

	/// fr: 'Intérieur'
	String get indoor => 'Intérieur';
}

// Path: widgets.navigation
class TranslationsWidgetsNavigationFr {
	TranslationsWidgetsNavigationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Explorer'
	String get explorer => 'Explorer';

	/// fr: 'À proximité'
	String get aroundMe => 'À proximité';

	/// fr: 'Ajouter'
	String get add => 'Ajouter';

	/// fr: 'Messages'
	String get messages => 'Messages';

	/// fr: 'Mon profil'
	String get profile => 'Mon profil';
}

// Path: widgets.error
class TranslationsWidgetsErrorFr {
	TranslationsWidgetsErrorFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Retour'
	String get back => 'Retour';

	/// fr: 'Essayer à nouveau'
	String get retry => 'Essayer à nouveau';

	/// fr: 'Se reconnecter'
	String get reconnect => 'Se reconnecter';

	late final TranslationsWidgetsErrorNetworkFr network = TranslationsWidgetsErrorNetworkFr.internal(_root);
	late final TranslationsWidgetsErrorServerFr server = TranslationsWidgetsErrorServerFr.internal(_root);
	late final TranslationsWidgetsErrorPermissionFr permission = TranslationsWidgetsErrorPermissionFr.internal(_root);
	late final TranslationsWidgetsErrorSessionFr session = TranslationsWidgetsErrorSessionFr.internal(_root);
	late final TranslationsWidgetsErrorNotFoundFr notFound = TranslationsWidgetsErrorNotFoundFr.internal(_root);
	late final TranslationsWidgetsErrorLocationFr location = TranslationsWidgetsErrorLocationFr.internal(_root);
	late final TranslationsWidgetsErrorValidationFr validation = TranslationsWidgetsErrorValidationFr.internal(_root);
	late final TranslationsWidgetsErrorUnexpectedFr unexpected = TranslationsWidgetsErrorUnexpectedFr.internal(_root);
	late final TranslationsWidgetsErrorAuthFr auth = TranslationsWidgetsErrorAuthFr.internal(_root);
}

// Path: widgets.common
class TranslationsWidgetsCommonFr {
	TranslationsWidgetsCommonFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'En voir +'
	String get viewMore => 'En voir +';

	/// fr: 'Annuler'
	String get cancel => 'Annuler';

	/// fr: 'Confirmer'
	String get confirm => 'Confirmer';
}

// Path: widgets.date
class TranslationsWidgetsDateFr {
	TranslationsWidgetsDateFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Aujourd'hui'
	String get today => 'Aujourd\'hui';

	/// fr: 'Hier'
	String get yesterday => 'Hier';

	late final TranslationsWidgetsDateDaysFr days = TranslationsWidgetsDateDaysFr.internal(_root);
}

// Path: widgets.notifications
class TranslationsWidgetsNotificationsFr {
	TranslationsWidgetsNotificationsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Plus tard'
	String get later => 'Plus tard';

	late final TranslationsWidgetsNotificationsPromptFr prompt = TranslationsWidgetsNotificationsPromptFr.internal(_root);
}

// Path: accountSettings.change_password.current_password
class TranslationsAccountSettingsChangePasswordCurrentPasswordFr {
	TranslationsAccountSettingsChangePasswordCurrentPasswordFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Entrez votre mot de passe actuel'
	String get section => 'Entrez votre mot de passe actuel';

	/// fr: 'Mot de passe actuel'
	String get label => 'Mot de passe actuel';

	/// fr: 'Entrez votre mot de passe actuel'
	String get hint => 'Entrez votre mot de passe actuel';
}

// Path: accountSettings.change_password.create
class TranslationsAccountSettingsChangePasswordCreateFr {
	TranslationsAccountSettingsChangePasswordCreateFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Créer un mot de passe'
	String get title => 'Créer un mot de passe';

	/// fr: 'Création du mot de passe…'
	String get loading => 'Création du mot de passe…';

	/// fr: 'Votre compte est lié à Google ou Facebook. Créez un mot de passe pour pouvoir aussi vous connecter avec ${email}.'
	String intro({required Object email}) => 'Votre compte est lié à Google ou Facebook. Créez un mot de passe pour pouvoir aussi vous connecter avec ${email}.';

	/// fr: 'Votre mot de passe a été créé. Vous pouvez maintenant vous connecter avec votre e-mail.'
	String get success => 'Votre mot de passe a été créé. Vous pouvez maintenant vous connecter avec votre e-mail.';
}

// Path: accountSettings.delete_account.dialog
class TranslationsAccountSettingsDeleteAccountDialogFr {
	TranslationsAccountSettingsDeleteAccountDialogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Supprimer mon compte'
	String get title => 'Supprimer mon compte';

	/// fr: 'Cette action est définitive. Toutes vos données (profil, catalogue, échanges et messages) seront supprimées et ne pourront pas être récupérées.'
	String get content => 'Cette action est définitive. Toutes vos données (profil, catalogue, échanges et messages) seront supprimées et ne pourront pas être récupérées.';

	/// fr: 'Supprimer'
	String get confirm => 'Supprimer';
}

// Path: accountSettings.notifications.permission_dialog
class TranslationsAccountSettingsNotificationsPermissionDialogFr {
	TranslationsAccountSettingsNotificationsPermissionDialogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Notifications désactivées'
	String get title => 'Notifications désactivées';

	/// fr: 'Pour être prévenu de vos nouveaux messages, autorisez PlantMatch à vous envoyer des notifications dans les réglages de votre téléphone.'
	String get content => 'Pour être prévenu de vos nouveaux messages, autorisez PlantMatch à vous envoyer des notifications dans les réglages de votre téléphone.';

	/// fr: 'Réglages'
	String get open_settings => 'Réglages';
}

// Path: auth.common.email
class TranslationsAuthCommonEmailFr {
	TranslationsAuthCommonEmailFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'E-mail'
	String get label => 'E-mail';

	/// fr: 'Entrez votre e-mail'
	String get hint => 'Entrez votre e-mail';

	/// fr: 'Ce champ est requis'
	String get required => 'Ce champ est requis';

	/// fr: 'Entrez un e-mail valide'
	String get invalid => 'Entrez un e-mail valide';
}

// Path: auth.common.password
class TranslationsAuthCommonPasswordFr {
	TranslationsAuthCommonPasswordFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Mot de passe'
	String get label => 'Mot de passe';

	/// fr: 'Entrez votre mot de passe'
	String get hint => 'Entrez votre mot de passe';

	/// fr: 'Ce champ est requis'
	String get required => 'Ce champ est requis';
}

// Path: auth.common.fullName
class TranslationsAuthCommonFullNameFr {
	TranslationsAuthCommonFullNameFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Prénom et nom'
	String get label => 'Prénom et nom';

	/// fr: 'Entrez votre prénom et nom'
	String get hint => 'Entrez votre prénom et nom';

	/// fr: 'Ce champ est requis'
	String get required => 'Ce champ est requis';
}

// Path: auth.common.firstName
class TranslationsAuthCommonFirstNameFr {
	TranslationsAuthCommonFirstNameFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Prénom'
	String get label => 'Prénom';

	/// fr: 'Entrez votre prénom'
	String get hint => 'Entrez votre prénom';

	/// fr: 'Ce champ est requis'
	String get required => 'Ce champ est requis';
}

// Path: auth.common.lastName
class TranslationsAuthCommonLastNameFr {
	TranslationsAuthCommonLastNameFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Nom'
	String get label => 'Nom';

	/// fr: 'Entrez votre nom'
	String get hint => 'Entrez votre nom';

	/// fr: 'Ce champ est requis'
	String get required => 'Ce champ est requis';
}

// Path: auth.signIn.social
class TranslationsAuthSignInSocialFr {
	TranslationsAuthSignInSocialFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Ou'
	String get title => 'Ou';

	/// fr: 'Continuer avec Google'
	String get google => 'Continuer avec Google';

	/// fr: 'Continuer avec Facebook'
	String get facebook => 'Continuer avec Facebook';
}

// Path: auth.register.confirmPassword
class TranslationsAuthRegisterConfirmPasswordFr {
	TranslationsAuthRegisterConfirmPasswordFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Confirmez le mot de passe'
	String get label => 'Confirmez le mot de passe';

	/// fr: 'Entrez le mot de passe'
	String get hint => 'Entrez le mot de passe';

	/// fr: 'Les mots de passe ne correspondent pas'
	String get mismatch => 'Les mots de passe ne correspondent pas';
}

// Path: auth.register.passwordRules
class TranslationsAuthRegisterPasswordRulesFr {
	TranslationsAuthRegisterPasswordRulesFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Au moins 8 caractères'
	String get minChars => 'Au moins 8 caractères';

	/// fr: 'Un chiffre'
	String get oneNumber => 'Un chiffre';

	/// fr: 'Une majuscule'
	String get oneUpper => 'Une majuscule';

	/// fr: 'Un caractère spécial'
	String get oneSpecial => 'Un caractère spécial';

	/// fr: 'Le mot de passe ne respecte pas les critères requis'
	String get error_rules => 'Le mot de passe ne respecte pas les critères requis';
}

// Path: auth.register.cgu
class TranslationsAuthRegisterCguFr {
	TranslationsAuthRegisterCguFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'J’accepte les '
	String get accept => 'J’accepte les ';

	/// fr: 'Conditions d’utilisation'
	String get terms => 'Conditions d’utilisation';

	/// fr: ' et je confirme avoir lu la '
	String get and => ' et je confirme avoir lu la ';

	/// fr: 'Politique de confidentialité'
	String get privacy => 'Politique de confidentialité';

	/// fr: ' de PlantMatch.'
	String get of => ' de PlantMatch.';
}

// Path: catalog.detail.delete_dialog
class TranslationsCatalogDetailDeleteDialogFr {
	TranslationsCatalogDetailDeleteDialogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Supprimer la plante'
	String get title => 'Supprimer la plante';

	/// fr: 'Êtes-vous sûr de vouloir supprimer "${name}" ? Cette action est irréversible.'
	String content({required Object name}) => 'Êtes-vous sûr de vouloir supprimer "${name}" ?\n\nCette action est irréversible.';

	/// fr: 'Annuler'
	String get cancel => 'Annuler';
}

// Path: catalog.edit.name
class TranslationsCatalogEditNameFr {
	TranslationsCatalogEditNameFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Nom de la plante'
	String get hint => 'Nom de la plante';

	/// fr: 'Nom'
	String get label => 'Nom';
}

// Path: catalog.edit.description
class TranslationsCatalogEditDescriptionFr {
	TranslationsCatalogEditDescriptionFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Ajouter une brève description'
	String get title => 'Ajouter une brève description';

	/// fr: 'Description de la plante'
	String get hint => 'Description de la plante';

	/// fr: 'Description'
	String get label => 'Description';

	/// fr: 'Maximum 150 caractères'
	String get max_length => 'Maximum 150 caractères';
}

// Path: catalog.edit.family
class TranslationsCatalogEditFamilyFr {
	TranslationsCatalogEditFamilyFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Sélectionner une ou des catégorie(s)'
	String get title => 'Sélectionner une ou des catégorie(s)';
}

// Path: catalog.edit.offer_type
class TranslationsCatalogEditOfferTypeFr {
	TranslationsCatalogEditOfferTypeFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Que souhaitez-vous faire de votre plante ?'
	String get title => 'Que souhaitez-vous faire de votre plante ?';
}

// Path: catalog.edit.maintenance
class TranslationsCatalogEditMaintenanceFr {
	TranslationsCatalogEditMaintenanceFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Sélectionner un niveau de difficulté'
	String get title => 'Sélectionner un niveau de difficulté';

	/// fr: 'Très résistante, peu d'arrosage'
	String get low_subtitle => 'Très résistante, peu d\'arrosage';

	/// fr: 'Quelques soins réguliers'
	String get medium_subtitle => 'Quelques soins réguliers';

	/// fr: 'Sensible, besoin de conditions spécifiques.'
	String get high_subtitle => 'Sensible, besoin de conditions spécifiques.';
}

// Path: catalog.edit.lighting
class TranslationsCatalogEditLightingFr {
	TranslationsCatalogEditLightingFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Sélectionner le besoin en lumière'
	String get title => 'Sélectionner le besoin en lumière';
}

// Path: catalog.edit.watering
class TranslationsCatalogEditWateringFr {
	TranslationsCatalogEditWateringFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Sélectionner le besoin en eau'
	String get title => 'Sélectionner le besoin en eau';
}

// Path: catalog.edit.environment
class TranslationsCatalogEditEnvironmentFr {
	TranslationsCatalogEditEnvironmentFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Sélectionner une catégorie pour votre plante'
	String get title => 'Sélectionner une catégorie pour votre plante';
}

// Path: catalog.edit.image
class TranslationsCatalogEditImageFr {
	TranslationsCatalogEditImageFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Sélectionner une à trois photos de votre plante'
	String get title => 'Sélectionner une à trois photos de votre plante';
}

// Path: catalog.wizard.quit_dialog
class TranslationsCatalogWizardQuitDialogFr {
	TranslationsCatalogWizardQuitDialogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Quitter sans enregistrer ?'
	String get title => 'Quitter sans enregistrer ?';

	/// fr: 'Les informations saisies seront perdues.'
	String get content => 'Les informations saisies seront perdues.';

	/// fr: 'Annuler'
	String get cancel => 'Annuler';

	/// fr: 'Quitter'
	String get quit => 'Quitter';
}

// Path: catalog.wizard.steps
class TranslationsCatalogWizardStepsFr {
	TranslationsCatalogWizardStepsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCatalogWizardStepsNameFr name = TranslationsCatalogWizardStepsNameFr.internal(_root);
	late final TranslationsCatalogWizardStepsCategoryFr category = TranslationsCatalogWizardStepsCategoryFr.internal(_root);
	late final TranslationsCatalogWizardStepsFamilyFr family = TranslationsCatalogWizardStepsFamilyFr.internal(_root);
	late final TranslationsCatalogWizardStepsDescriptionFr description = TranslationsCatalogWizardStepsDescriptionFr.internal(_root);
	late final TranslationsCatalogWizardStepsImageFr image = TranslationsCatalogWizardStepsImageFr.internal(_root);
	late final TranslationsCatalogWizardStepsWateringFr watering = TranslationsCatalogWizardStepsWateringFr.internal(_root);
	late final TranslationsCatalogWizardStepsLightingFr lighting = TranslationsCatalogWizardStepsLightingFr.internal(_root);
	late final TranslationsCatalogWizardStepsMaintenanceFr maintenance = TranslationsCatalogWizardStepsMaintenanceFr.internal(_root);
	late final TranslationsCatalogWizardStepsOfferTypeFr offer_type = TranslationsCatalogWizardStepsOfferTypeFr.internal(_root);
	late final TranslationsCatalogWizardStepsPublishFr publish = TranslationsCatalogWizardStepsPublishFr.internal(_root);
}

// Path: catalog.enums.lighting
class TranslationsCatalogEnumsLightingFr {
	TranslationsCatalogEnumsLightingFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Soleil'
	String get sun => 'Soleil';

	/// fr: 'Indirecte'
	String get indirect => 'Indirecte';

	/// fr: 'Ombre'
	String get shade => 'Ombre';
}

// Path: catalog.enums.environment
class TranslationsCatalogEnumsEnvironmentFr {
	TranslationsCatalogEnumsEnvironmentFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Intérieur'
	String get indoor => 'Intérieur';

	/// fr: 'Extérieur'
	String get outdoor => 'Extérieur';
}

// Path: catalog.enums.maintenance
class TranslationsCatalogEnumsMaintenanceFr {
	TranslationsCatalogEnumsMaintenanceFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Facile'
	String get low => 'Facile';

	/// fr: 'Moyen'
	String get medium => 'Moyen';

	/// fr: 'Difficile'
	String get high => 'Difficile';
}

// Path: catalog.enums.watering
class TranslationsCatalogEnumsWateringFr {
	TranslationsCatalogEnumsWateringFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Peu d'eau'
	String get little => 'Peu d\'eau';

	/// fr: 'Régulier'
	String get regularly => 'Régulier';
}

// Path: catalog.enums.offer_type
class TranslationsCatalogEnumsOfferTypeFr {
	TranslationsCatalogEnumsOfferTypeFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Échange'
	String get exchange => 'Échange';

	/// fr: 'Donation'
	String get donation => 'Donation';
}

// Path: chatPlant.view.unblock_dialog
class TranslationsChatPlantViewUnblockDialogFr {
	TranslationsChatPlantViewUnblockDialogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Débloquer cet utilisateur ?'
	String get title => 'Débloquer cet utilisateur ?';

	/// fr: 'Cette personne pourra à nouveau vous envoyer des messages.'
	String get content => 'Cette personne pourra à nouveau vous envoyer des messages.';

	/// fr: 'Débloquer'
	String get confirm => 'Débloquer';
}

// Path: chatPlant.view.status
class TranslationsChatPlantViewStatusFr {
	TranslationsChatPlantViewStatusFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'L'échange est accepté ! En attente de la rencontre.'
	String get exchange_accepted_waiting => 'L\'échange est accepté ! En attente de la rencontre.';

	/// fr: 'La donation est acceptée ! En attente de la rencontre.'
	String get donation_accepted_waiting => 'La donation est acceptée ! En attente de la rencontre.';
}

// Path: chatPlant.menu.delete_dialog
class TranslationsChatPlantMenuDeleteDialogFr {
	TranslationsChatPlantMenuDeleteDialogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Effacer la conversation'
	String get title => 'Effacer la conversation';

	/// fr: 'Elle sera supprimée uniquement pour vous.'
	String get content => 'Elle sera supprimée uniquement pour vous.';
}

// Path: chatPlant.menu.report_dialog
class TranslationsChatPlantMenuReportDialogFr {
	TranslationsChatPlantMenuReportDialogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Signaler'
	String get title => 'Signaler';

	/// fr: 'Cette conversation sera transmise à l'équipe PlantMatch pour examen. Merci de nous aider à maintenir une communauté saine.'
	String get content => 'Cette conversation sera transmise à l\'équipe PlantMatch pour examen. Merci de nous aider à maintenir une communauté saine.';
}

// Path: chatPlant.menu.block_dialog
class TranslationsChatPlantMenuBlockDialogFr {
	TranslationsChatPlantMenuBlockDialogFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Bloquer cet utilisateur ?'
	String get title => 'Bloquer cet utilisateur ?';

	/// fr: 'Cette personne ne pourra plus vous envoyer de messages ni voir votre profil.'
	String get content => 'Cette personne ne pourra plus vous envoyer de messages ni voir votre profil.';

	/// fr: 'Attention : un échange est en cours. Bloquer cet utilisateur notifiera l'équipe PlantMatch et aucun point ne sera distribué.'
	String get warning_active_transaction => 'Attention : un échange est en cours. Bloquer cet utilisateur notifiera l\'équipe PlantMatch et aucun point ne sera distribué.';
}

// Path: chatPlant.actions.labels
class TranslationsChatPlantActionsLabelsFr {
	TranslationsChatPlantActionsLabelsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'l'échange'
	String get exchange => 'l\'échange';

	/// fr: 'la donation'
	String get donation => 'la donation';
}

// Path: chatPlant.info_bar.exchange
class TranslationsChatPlantInfoBarExchangeFr {
	TranslationsChatPlantInfoBarExchangeFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Une demande d'échange est en attente de réponse'
	String get pending => 'Une demande d\'échange est en attente de réponse';

	/// fr: 'Échange accepté 🎉'
	String get accepted => 'Échange accepté 🎉';

	/// fr: 'Échange refusé'
	String get rejected => 'Échange refusé';

	/// fr: 'Échange terminé ✅'
	String get completed => 'Échange terminé ✅';
}

// Path: chatPlant.info_bar.donation
class TranslationsChatPlantInfoBarDonationFr {
	TranslationsChatPlantInfoBarDonationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Une demande de donation est en attente de réponse'
	String get pending => 'Une demande de donation est en attente de réponse';

	/// fr: 'Donation acceptée 🎉'
	String get accepted => 'Donation acceptée 🎉';

	/// fr: 'Donation refusée'
	String get rejected => 'Donation refusée';

	/// fr: 'Donation terminée ✅'
	String get completed => 'Donation terminée ✅';
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

	/// fr: 'Transformer vos dons en feuilles bonus'
	String get description => 'Transformer vos dons en feuilles bonus';
}

// Path: level.levels.k1
class TranslationsLevelLevelsK1Fr {
	TranslationsLevelLevelsK1Fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Inscription sur PlantMatch.'
	String get condition => 'Inscription sur PlantMatch.';

	/// fr: 'Bienvenue dans la communauté ! Tu viens de planter ta première graine.'
	String get description => 'Bienvenue dans la communauté ! Tu viens de planter ta première graine.';

	late final TranslationsLevelLevelsK1ActionsFr actions = TranslationsLevelLevelsK1ActionsFr.internal(_root);
}

// Path: level.levels.k2
class TranslationsLevelLevelsK2Fr {
	TranslationsLevelLevelsK2Fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Réaliser 2 dons ou échanges confirmés.'
	String get condition => 'Réaliser 2 dons ou échanges confirmés.';

	/// fr: 'Tu commences à échanger et donner tes plantes avec la communauté !'
	String get description => 'Tu commences à échanger et donner tes plantes avec la communauté !';

	late final TranslationsLevelLevelsK2ActionsFr actions = TranslationsLevelLevelsK2ActionsFr.internal(_root);
}

// Path: level.levels.k3
class TranslationsLevelLevelsK3Fr {
	TranslationsLevelLevelsK3Fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Réaliser 5 dons ou échanges confirmés.'
	String get condition => 'Réaliser 5 dons ou échanges confirmés.';

	/// fr: 'Un cultivateur actif qui partage régulièrement ses boutures !'
	String get description => 'Un cultivateur actif qui partage régulièrement ses boutures !';

	late final TranslationsLevelLevelsK3ActionsFr actions = TranslationsLevelLevelsK3ActionsFr.internal(_root);
}

// Path: level.levels.k4
class TranslationsLevelLevelsK4Fr {
	TranslationsLevelLevelsK4Fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Réaliser 10 dons ou échanges confirmés.'
	String get condition => 'Réaliser 10 dons ou échanges confirmés.';

	/// fr: 'Un jardinier confirmé réputé pour sa générosité !'
	String get description => 'Un jardinier confirmé réputé pour sa générosité !';

	late final TranslationsLevelLevelsK4ActionsFr actions = TranslationsLevelLevelsK4ActionsFr.internal(_root);
}

// Path: level.levels.k5
class TranslationsLevelLevelsK5Fr {
	TranslationsLevelLevelsK5Fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Réaliser 25 dons ou échanges confirmés.'
	String get condition => 'Réaliser 25 dons ou échanges confirmés.';

	/// fr: 'Expert des plantes de la communauté PlantMatch !'
	String get description => 'Expert des plantes de la communauté PlantMatch !';

	late final TranslationsLevelLevelsK5ActionsFr actions = TranslationsLevelLevelsK5ActionsFr.internal(_root);
}

// Path: level.levels.k6
class TranslationsLevelLevelsK6Fr {
	TranslationsLevelLevelsK6Fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Réaliser 50 dons ou échanges confirmés.'
	String get condition => 'Réaliser 50 dons ou échanges confirmés.';

	/// fr: 'Maître du jardinage d'exception !'
	String get description => 'Maître du jardinage d\'exception !';

	late final TranslationsLevelLevelsK6ActionsFr actions = TranslationsLevelLevelsK6ActionsFr.internal(_root);
}

// Path: level.levels.k7
class TranslationsLevelLevelsK7Fr {
	TranslationsLevelLevelsK7Fr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Réaliser 100 dons ou échanges confirmés.'
	String get condition => 'Réaliser 100 dons ou échanges confirmés.';

	/// fr: 'Gardien de la nature légendaire de PlantMatch !'
	String get description => 'Gardien de la nature légendaire de PlantMatch !';

	late final TranslationsLevelLevelsK7ActionsFr actions = TranslationsLevelLevelsK7ActionsFr.internal(_root);
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

// Path: personalInformation.detail.clear
class TranslationsPersonalInformationDetailClearFr {
	TranslationsPersonalInformationDetailClearFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Effacer « $field » ?'
	String title({required Object field}) => 'Effacer « ${field} » ?';

	/// fr: 'Cette information sera supprimée de votre profil.'
	String get content => 'Cette information sera supprimée de votre profil.';

	/// fr: 'Effacer'
	String get confirm => 'Effacer';
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

	/// fr: 'Passer'
	String get skip => 'Passer';

	/// fr: 'Terminer'
	String get finish => 'Terminer';

	/// fr: 'Enregistrer'
	String get save => 'Enregistrer';

	/// fr: 'Mettre à jour ma position'
	String get update_location => 'Mettre à jour ma position';
}

// Path: personalInformation.wizard.referral
class TranslationsPersonalInformationWizardReferralFr {
	TranslationsPersonalInformationWizardReferralFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Code de parrainage'
	String get title => 'Code de parrainage';

	/// fr: 'Si un ami vous a parrainé, saisissez son code pour gagner tous les deux 3 feuilles supplémentaires !'
	String get description => 'Si un ami vous a parrainé, saisissez son code pour gagner tous les deux 3 feuilles supplémentaires !';

	/// fr: 'Ex : PM-XYZ12'
	String get hint => 'Ex : PM-XYZ12';

	/// fr: 'Code de parrainage (Optionnel)'
	String get label => 'Code de parrainage (Optionnel)';
}

// Path: personalInformation.wizard.leave
class TranslationsPersonalInformationWizardLeaveFr {
	TranslationsPersonalInformationWizardLeaveFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Quitter sans enregistrer ?'
	String get title => 'Quitter sans enregistrer ?';

	/// fr: 'Vos modifications ne seront pas enregistrées.'
	String get content => 'Vos modifications ne seront pas enregistrées.';

	/// fr: 'Quitter'
	String get confirm => 'Quitter';
}

// Path: profil.navigation.navigation_title
class TranslationsProfilNavigationNavigationTitleFr {
	TranslationsProfilNavigationNavigationTitleFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Les essentiels'
	String get essential => 'Les essentiels';

	/// fr: 'Personnalisation'
	String get personalization => 'Personnalisation';

	/// fr: 'PlantMatch'
	String get plant_match => 'PlantMatch';
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

// Path: user.detail_plant.no_leaves
class TranslationsUserDetailPlantNoLeavesFr {
	TranslationsUserDetailPlantNoLeavesFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Plus de feuilles disponibles'
	String get title => 'Plus de feuilles disponibles';

	/// fr: 'Vous n'avez plus de feuilles pour contacter un donneur. Donnez ou échangez une plante (+2 feuilles) ou parrainez un ami (+3 feuilles) pour continuer !'
	String get content => 'Vous n\'avez plus de feuilles pour contacter un donneur.\n\nDonnez ou échangez une plante (+2 feuilles) ou parrainez un ami (+3 feuilles) pour continuer !';

	/// fr: 'D'accord'
	String get ok => 'D\'accord';
}

// Path: user.detail_plant.share
class TranslationsUserDetailPlantShareFr {
	TranslationsUserDetailPlantShareFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'donne'
	String get donation => 'donne';

	/// fr: 'échange'
	String get exchange => 'échange';

	/// fr: 'Regarde cette plante sur PlantMatch ! Je $type une magnifique *$name*. "$description" Télécharge l'application PlantMatch pour l'adopter ou l'échanger autour de toi ! 🌿'
	String text({required Object type, required Object name, required Object description}) => 'Regarde cette plante sur PlantMatch !\n\nJe ${type} une magnifique *${name}*.\n"${description}"\n\nTélécharge l\'application PlantMatch pour l\'adopter ou l\'échanger autour de toi ! 🌿';
}

// Path: widgets.error.network
class TranslationsWidgetsErrorNetworkFr {
	TranslationsWidgetsErrorNetworkFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Pas de connexion'
	String get title => 'Pas de connexion';

	/// fr: 'Vérifiez votre connexion internet puis réessayez.'
	String get message => 'Vérifiez votre connexion internet puis réessayez.';
}

// Path: widgets.error.server
class TranslationsWidgetsErrorServerFr {
	TranslationsWidgetsErrorServerFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Service momentanément indisponible'
	String get title => 'Service momentanément indisponible';

	/// fr: 'Nos serveurs rencontrent un souci. Réessayez dans quelques instants.'
	String get message => 'Nos serveurs rencontrent un souci. Réessayez dans quelques instants.';
}

// Path: widgets.error.permission
class TranslationsWidgetsErrorPermissionFr {
	TranslationsWidgetsErrorPermissionFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Accès refusé'
	String get title => 'Accès refusé';

	/// fr: 'Vous n'avez pas les droits pour accéder à ce contenu.'
	String get message => 'Vous n\'avez pas les droits pour accéder à ce contenu.';
}

// Path: widgets.error.session
class TranslationsWidgetsErrorSessionFr {
	TranslationsWidgetsErrorSessionFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Session expirée'
	String get title => 'Session expirée';

	/// fr: 'Reconnectez-vous pour continuer.'
	String get message => 'Reconnectez-vous pour continuer.';
}

// Path: widgets.error.notFound
class TranslationsWidgetsErrorNotFoundFr {
	TranslationsWidgetsErrorNotFoundFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Contenu introuvable'
	String get title => 'Contenu introuvable';

	/// fr: 'Ce contenu n'existe plus ou a été supprimé.'
	String get message => 'Ce contenu n\'existe plus ou a été supprimé.';
}

// Path: widgets.error.location
class TranslationsWidgetsErrorLocationFr {
	TranslationsWidgetsErrorLocationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Localisation impossible'
	String get title => 'Localisation impossible';

	/// fr: 'La localisation est désactivée. Activez-la dans les réglages de votre téléphone.'
	String get disabled => 'La localisation est désactivée. Activez-la dans les réglages de votre téléphone.';

	/// fr: 'PlantMatch n'a pas accès à votre position. Autorisez la localisation dans les réglages.'
	String get denied => 'PlantMatch n\'a pas accès à votre position. Autorisez la localisation dans les réglages.';

	/// fr: 'Impossible d'obtenir votre position pour le moment. Réessayez dans un instant.'
	String get unavailable => 'Impossible d\'obtenir votre position pour le moment. Réessayez dans un instant.';
}

// Path: widgets.error.validation
class TranslationsWidgetsErrorValidationFr {
	TranslationsWidgetsErrorValidationFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Action impossible'
	String get title => 'Action impossible';
}

// Path: widgets.error.unexpected
class TranslationsWidgetsErrorUnexpectedFr {
	TranslationsWidgetsErrorUnexpectedFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Oups ! une erreur est survenue'
	String get title => 'Oups ! une erreur est survenue';

	/// fr: 'Quelque chose s'est mal passé. Réessayez dans un instant.'
	String get message => 'Quelque chose s\'est mal passé. Réessayez dans un instant.';
}

// Path: widgets.error.auth
class TranslationsWidgetsErrorAuthFr {
	TranslationsWidgetsErrorAuthFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Connexion impossible'
	String get title => 'Connexion impossible';

	/// fr: 'L'email ou le mot de passe est incorrect.'
	String get invalidCredentials => 'L\'email ou le mot de passe est incorrect.';

	/// fr: 'L'adresse email n'est pas valide.'
	String get invalidEmail => 'L\'adresse email n\'est pas valide.';

	/// fr: 'Ce compte a été désactivé.'
	String get userDisabled => 'Ce compte a été désactivé.';

	/// fr: 'Un compte existe déjà avec cette adresse email.'
	String get emailAlreadyInUse => 'Un compte existe déjà avec cette adresse email.';

	/// fr: 'Un compte existe déjà avec cette adresse email via un autre mode de connexion.'
	String get accountExistsWithDifferentCredential => 'Un compte existe déjà avec cette adresse email via un autre mode de connexion.';

	/// fr: 'Le mot de passe est trop faible.'
	String get weakPassword => 'Le mot de passe est trop faible.';

	/// fr: 'Trop de tentatives. Patientez quelques minutes avant de réessayer.'
	String get tooManyRequests => 'Trop de tentatives. Patientez quelques minutes avant de réessayer.';

	/// fr: 'La connexion a été annulée.'
	String get cancelled => 'La connexion a été annulée.';

	/// fr: 'La connexion avec ce service a échoué. Réessayez.'
	String get provider => 'La connexion avec ce service a échoué. Réessayez.';

	/// fr: 'Votre adresse email est déjà vérifiée.'
	String get emailAlreadyVerified => 'Votre adresse email est déjà vérifiée.';

	/// fr: 'Votre adresse email n'est pas encore vérifiée.'
	String get emailNotVerified => 'Votre adresse email n\'est pas encore vérifiée.';

	/// fr: 'Votre profil n'est pas encore finalisé.'
	String get profileMissing => 'Votre profil n\'est pas encore finalisé.';

	/// fr: 'Aucune adresse e-mail n'est associée à votre compte.'
	String get noEmail => 'Aucune adresse e-mail n\'est associée à votre compte.';
}

// Path: widgets.date.days
class TranslationsWidgetsDateDaysFr {
	TranslationsWidgetsDateDaysFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Lundi'
	String get monday => 'Lundi';

	/// fr: 'Mardi'
	String get tuesday => 'Mardi';

	/// fr: 'Mercredi'
	String get wednesday => 'Mercredi';

	/// fr: 'Jeudi'
	String get thursday => 'Jeudi';

	/// fr: 'Vendredi'
	String get friday => 'Vendredi';

	/// fr: 'Samedi'
	String get saturday => 'Samedi';

	/// fr: 'Dimanche'
	String get sunday => 'Dimanche';
}

// Path: widgets.notifications.prompt
class TranslationsWidgetsNotificationsPromptFr {
	TranslationsWidgetsNotificationsPromptFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Ne manquez aucune réponse'
	String get title => 'Ne manquez aucune réponse';

	/// fr: 'Activez les notifications pour être prévenu dès que vous recevez un nouveau message.'
	String get content => 'Activez les notifications pour être prévenu dès que vous recevez un nouveau message.';

	/// fr: 'Activer'
	String get confirm => 'Activer';
}

// Path: catalog.wizard.steps.name
class TranslationsCatalogWizardStepsNameFr {
	TranslationsCatalogWizardStepsNameFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Nom de la plante'
	String get title => 'Nom de la plante';

	/// fr: 'Entrez le nom de la plante'
	String get description => 'Entrez le nom de la plante';

	/// fr: 'Nom'
	String get label => 'Nom';

	/// fr: 'Nom'
	String get hint => 'Nom';
}

// Path: catalog.wizard.steps.category
class TranslationsCatalogWizardStepsCategoryFr {
	TranslationsCatalogWizardStepsCategoryFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Quel environnement ?'
	String get title => 'Quel environnement ?';

	/// fr: 'Sélectionnez une catégorie'
	String get description => 'Sélectionnez une catégorie';

	/// fr: 'Intérieur'
	String get indoor => 'Intérieur';

	/// fr: 'Extérieur'
	String get outdoor => 'Extérieur';
}

// Path: catalog.wizard.steps.family
class TranslationsCatalogWizardStepsFamilyFr {
	TranslationsCatalogWizardStepsFamilyFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Choisir une famille'
	String get title => 'Choisir une famille';

	/// fr: 'Sélectionnez une ou des catégorie(s)'
	String get description => 'Sélectionnez une ou des catégorie(s)';
}

// Path: catalog.wizard.steps.description
class TranslationsCatalogWizardStepsDescriptionFr {
	TranslationsCatalogWizardStepsDescriptionFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Description'
	String get title => 'Description';

	/// fr: 'Ajouter une brève description'
	String get description => 'Ajouter une brève description';

	/// fr: 'Description'
	String get label => 'Description';

	/// fr: 'Description'
	String get hint => 'Description';
}

// Path: catalog.wizard.steps.image
class TranslationsCatalogWizardStepsImageFr {
	TranslationsCatalogWizardStepsImageFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Ajouter une photo'
	String get title => 'Ajouter une photo';

	/// fr: 'Sélectionner une à trois photos de votre plante'
	String get description => 'Sélectionner une à trois photos de votre plante';
}

// Path: catalog.wizard.steps.watering
class TranslationsCatalogWizardStepsWateringFr {
	TranslationsCatalogWizardStepsWateringFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Arrosage'
	String get title => 'Arrosage';

	/// fr: 'Besoin en eau'
	String get description => 'Besoin en eau';

	/// fr: 'Eau'
	String get label => 'Eau';

	/// fr: 'Peu d'eau'
	String get little => 'Peu d\'eau';

	/// fr: 'Régulier'
	String get regularly => 'Régulier';
}

// Path: catalog.wizard.steps.lighting
class TranslationsCatalogWizardStepsLightingFr {
	TranslationsCatalogWizardStepsLightingFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Lumière'
	String get title => 'Lumière';

	/// fr: 'Besoin en lumière'
	String get description => 'Besoin en lumière';

	/// fr: 'Lumière'
	String get label => 'Lumière';

	/// fr: 'Soleil'
	String get sun => 'Soleil';

	/// fr: 'Indirecte'
	String get indirect => 'Indirecte';

	/// fr: 'Ombre'
	String get shade => 'Ombre';
}

// Path: catalog.wizard.steps.maintenance
class TranslationsCatalogWizardStepsMaintenanceFr {
	TranslationsCatalogWizardStepsMaintenanceFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Entretien'
	String get title => 'Entretien';

	/// fr: 'Niveau de difficulté'
	String get description => 'Niveau de difficulté';

	/// fr: 'Difficulté'
	String get label => 'Difficulté';

	/// fr: 'Facile'
	String get low => 'Facile';

	/// fr: 'Moyen'
	String get medium => 'Moyen';

	/// fr: 'Difficile'
	String get high => 'Difficile';
}

// Path: catalog.wizard.steps.offer_type
class TranslationsCatalogWizardStepsOfferTypeFr {
	TranslationsCatalogWizardStepsOfferTypeFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Offre'
	String get title => 'Offre';

	/// fr: 'Que faire de votre plante ?'
	String get description => 'Que faire de votre plante ?';

	/// fr: 'Donation'
	String get donation => 'Donation';

	/// fr: 'Echange'
	String get exchange => 'Echange';
}

// Path: catalog.wizard.steps.publish
class TranslationsCatalogWizardStepsPublishFr {
	TranslationsCatalogWizardStepsPublishFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Publication'
	String get title => 'Publication';

	/// fr: 'Publier maintenant ?'
	String get description => 'Publier maintenant ?';
}

// Path: level.levels.k1.actions
class TranslationsLevelLevelsK1ActionsFr {
	TranslationsLevelLevelsK1ActionsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: 'Inscription'
	String get registration => 'Inscription';

	/// fr: 'Pack de bienvenue (5 feuilles)'
	String get first_plant => 'Pack de bienvenue (5 feuilles)';
}

// Path: level.levels.k2.actions
class TranslationsLevelLevelsK2ActionsFr {
	TranslationsLevelLevelsK2ActionsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: '2 dons ou échanges réussis (+3 feuilles bonus)'
	String get first_exchange => '2 dons ou échanges réussis (+3 feuilles bonus)';
}

// Path: level.levels.k3.actions
class TranslationsLevelLevelsK3ActionsFr {
	TranslationsLevelLevelsK3ActionsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: '5 dons ou échanges réussis (+5 feuilles bonus)'
	String get exchange => '5 dons ou échanges réussis (+5 feuilles bonus)';
}

// Path: level.levels.k4.actions
class TranslationsLevelLevelsK4ActionsFr {
	TranslationsLevelLevelsK4ActionsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: '10 dons ou échanges réussis (+8 feuilles bonus)'
	String get exchange => '10 dons ou échanges réussis (+8 feuilles bonus)';
}

// Path: level.levels.k5.actions
class TranslationsLevelLevelsK5ActionsFr {
	TranslationsLevelLevelsK5ActionsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: '25 dons ou échanges réussis (+12 feuilles bonus)'
	String get exchange => '25 dons ou échanges réussis (+12 feuilles bonus)';
}

// Path: level.levels.k6.actions
class TranslationsLevelLevelsK6ActionsFr {
	TranslationsLevelLevelsK6ActionsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: '50 dons ou échanges réussis (+20 feuilles bonus)'
	String get exchange => '50 dons ou échanges réussis (+20 feuilles bonus)';
}

// Path: level.levels.k7.actions
class TranslationsLevelLevelsK7ActionsFr {
	TranslationsLevelLevelsK7ActionsFr.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// fr: '100 dons ou échanges réussis (Feuilles illimitées)'
	String get exchange => '100 dons ou échanges réussis (Feuilles illimitées)';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'accountSettings.screen.title' => 'Paramètres de compte',
			'accountSettings.items.change_password' => 'Modifier mon mot de passe',
			'accountSettings.items.notifications' => 'Notifications',
			'accountSettings.items.notification_settings' => 'Paramètres de notification',
			'accountSettings.items.location_access' => 'Accès à ma position',
			'accountSettings.change_password.current_password.section' => 'Entrez votre mot de passe actuel',
			'accountSettings.change_password.current_password.label' => 'Mot de passe actuel',
			'accountSettings.change_password.current_password.hint' => 'Entrez votre mot de passe actuel',
			'accountSettings.change_password.new_password_section' => 'Choisissez un nouveau mot de passe',
			'accountSettings.change_password.new_password_label' => 'Nouveau mot de passe',
			'accountSettings.change_password.submit' => 'Envoyer',
			'accountSettings.change_password.loading' => 'Modification du mot de passe…',
			'accountSettings.change_password.success' => 'Votre mot de passe a été modifié.',
			'accountSettings.change_password.wrong_current_password' => 'Le mot de passe actuel est incorrect.',
			'accountSettings.change_password.create.title' => 'Créer un mot de passe',
			'accountSettings.change_password.create.loading' => 'Création du mot de passe…',
			'accountSettings.change_password.create.intro' => ({required Object email}) => 'Votre compte est lié à Google ou Facebook. Créez un mot de passe pour pouvoir aussi vous connecter avec ${email}.',
			'accountSettings.change_password.create.success' => 'Votre mot de passe a été créé. Vous pouvez maintenant vous connecter avec votre e-mail.',
			'accountSettings.change_password.unavailable' => 'Votre compte est lié à un réseau social qui ne nous a pas transmis d\'adresse e-mail. Vous ne pouvez donc pas créer de mot de passe : continuez à vous connecter avec ce réseau social.',
			'accountSettings.delete_account.button' => 'Supprimer mon compte',
			'accountSettings.delete_account.error_title' => 'Suppression impossible',
			'accountSettings.delete_account.loading' => 'Suppression du compte…',
			'accountSettings.delete_account.dialog.title' => 'Supprimer mon compte',
			'accountSettings.delete_account.dialog.content' => 'Cette action est définitive. Toutes vos données (profil, catalogue, échanges et messages) seront supprimées et ne pourront pas être récupérées.',
			'accountSettings.delete_account.dialog.confirm' => 'Supprimer',
			'accountSettings.notifications.enabling' => 'Activation des notifications…',
			'accountSettings.notifications.disabling' => 'Désactivation des notifications…',
			'accountSettings.notifications.permission_dialog.title' => 'Notifications désactivées',
			'accountSettings.notifications.permission_dialog.content' => 'Pour être prévenu de vos nouveaux messages, autorisez PlantMatch à vous envoyer des notifications dans les réglages de votre téléphone.',
			'accountSettings.notifications.permission_dialog.open_settings' => 'Réglages',
			'aroundMeMap.header.title' => 'A proximité',
			'aroundMeMap.header.subtitle' => 'Trouvez des utilisateurs autour de vous pour partager, échanger ...',
			'aroundMeMap.empty.title' => 'Oups ! vous n\'êtes pas localisé',
			'aroundMeMap.empty.description' => 'Veuillez activer votre localisation pour voir les utilisateurs autour de vous',
			'aroundMeMap.empty.button' => 'Me géolocaliser',
			'aroundMeMap.bottomSheet.title' => 'Plantes & Boutures',
			'aroundMeMap.bottomSheet.description' => 'Mon catalogue de ce que j’ai à partager',
			'aroundMeMap.bottomSheet.viewProfile' => 'Voir le profil',
			'aroundMeMap.card.plantEnv' => ({required Object env}) => 'plante ${env}',
			'aroundMeMap.catalogUsers.empty' => 'Aucun catalogue disponible',
			'aroundMeMap.catalogUsers.userNoCatalog' => ({required Object name}) => '${name} n\'a pas encore de catalogue.',
			'aroundMeMap.status.online' => 'En ligne',
			'aroundMeMap.status.offline' => 'Hors ligne',
			'aroundMeMap.distance' => ({required Object value}) => '${value} km',
			'aroundMeMap.map.empty_title' => 'Aucune plante trouvée dans ce rayon',
			'aroundMeMap.map.empty_widen' => 'Élargissez le rayon de recherche pour découvrir plus de plantes autour de vous.',
			'aroundMeMap.map.empty_first' => 'Soyez le premier à publier une plante dans l\'application !',
			'aroundMeMap.map.empty_widen_btn' => 'Élargir le rayon',
			'aroundMeMap.map.empty_close_btn' => 'Compris',
			'aroundMeMap.radius.title' => 'Rayon de recherche',
			'aroundMeMap.radius.description' => 'Définissez la distance maximale pour découvrir des plantes autour de vous.',
			'aroundMeMap.radius.within' => 'Dans un rayon de',
			'aroundMeMap.radius.apply' => 'Appliquer',
			'auth.common.email.label' => 'E-mail',
			'auth.common.email.hint' => 'Entrez votre e-mail',
			'auth.common.email.required' => 'Ce champ est requis',
			'auth.common.email.invalid' => 'Entrez un e-mail valide',
			'auth.common.password.label' => 'Mot de passe',
			'auth.common.password.hint' => 'Entrez votre mot de passe',
			'auth.common.password.required' => 'Ce champ est requis',
			'auth.common.fullName.label' => 'Prénom et nom',
			'auth.common.fullName.hint' => 'Entrez votre prénom et nom',
			'auth.common.fullName.required' => 'Ce champ est requis',
			'auth.common.firstName.label' => 'Prénom',
			'auth.common.firstName.hint' => 'Entrez votre prénom',
			'auth.common.firstName.required' => 'Ce champ est requis',
			'auth.common.lastName.label' => 'Nom',
			'auth.common.lastName.hint' => 'Entrez votre nom',
			'auth.common.lastName.required' => 'Ce champ est requis',
			'auth.common.back' => 'Retour',
			'auth.common.confirm' => 'Confirmer',
			'auth.common.ok' => 'Ok',
			'auth.common.error_title' => 'Oups !\nune erreur est survénue 🫤',
			'auth.signIn.title' => 'Hey! Bienvenue',
			'auth.signIn.forgotPassword' => 'Mot de passe oublié ?',
			'auth.signIn.noAccount' => 'Pas encore de compte ?',
			'auth.signIn.createAccount' => 'Créer un compte',
			'auth.signIn.social.title' => 'Ou',
			'auth.signIn.social.google' => 'Continuer avec Google',
			'auth.signIn.social.facebook' => 'Continuer avec Facebook',
			'auth.signIn.login' => 'Se connecter',
			'auth.register.title' => 'Créer un compte',
			'auth.register.welcome' => 'Commencez !',
			'auth.register.description' => 'Il semblerait que vous soyez nouveau ici. Créons votre profil.',
			'auth.register.confirmPassword.label' => 'Confirmez le mot de passe',
			'auth.register.confirmPassword.hint' => 'Entrez le mot de passe',
			'auth.register.confirmPassword.mismatch' => 'Les mots de passe ne correspondent pas',
			'auth.register.alreadyHaveAccount' => 'Vous avez déjà un compte ?',
			'auth.register.signIn' => 'S\'identifier',
			'auth.register.passwordRules.minChars' => 'Au moins 8 caractères',
			'auth.register.passwordRules.oneNumber' => 'Un chiffre',
			'auth.register.passwordRules.oneUpper' => 'Une majuscule',
			'auth.register.passwordRules.oneSpecial' => 'Un caractère spécial',
			'auth.register.passwordRules.error_rules' => 'Le mot de passe ne respecte pas les critères requis',
			'auth.register.cgu.accept' => 'J’accepte les ',
			'auth.register.cgu.terms' => 'Conditions d’utilisation',
			'auth.register.cgu.and' => ' et je confirme avoir lu la ',
			'auth.register.cgu.privacy' => 'Politique de confidentialité',
			'auth.register.cgu.of' => ' de PlantMatch.',
			'auth.forgotPassword.title' => 'Mot de passe oublié ?',
			'auth.forgotPassword.description' => 'Entrez votre e-mail pour réinitialiser le mot de passe',
			'auth.forgotPassword.emailSent' => ({required Object email}) => 'Un e-mail de réinitialisation a été envoyé sur ${email}',
			'auth.forgotPassword.send' => 'Envoyer',
			'auth.emailVerification.title' => 'Validez votre compte',
			'auth.emailVerification.description' => 'Un e-mail a été envoyé à votre adresse :\n',
			'auth.emailVerification.instruction' => '\nCliquez sur le lien pour vérifier votre e-mail avant de continuer.',
			'auth.emailVerification.resendEmailSent' => 'Un nouvel e-mail de vérification a été envoyé.',
			'auth.emailVerification.finalizing' => 'Finalisation de votre inscription...',
			'auth.emailVerification.resendBtn' => 'Renvoyer l\'e-mail',
			'auth.emailVerification.retryLabel' => ({required Object count}) => 'Réessayez dans ${count} s',
			'auth.register_choice.title' => 'Comment souhaitez-vous créer votre compte ?',
			'auth.register_choice.description' => 'Créer votre compte avec votre adresse e-mail ou continuez avec votre méthode préférée.',
			'auth.register_choice.email' => 'Continuer avec un e-mail',
			'auth.register_choice.google' => 'Continuer avec Google',
			'auth.register_choice.facebook' => 'Continuer avec Facebook',
			'catalog.screen.title' => 'Mes plantes',
			'catalog.screen.subtitle' => 'Mon catalogue de plantes à partager',
			'catalog.screen.empty_message' => 'Ton catalogue est vide. Ajoute ta première plante pour commencer.',
			'catalog.tabs.published' => ({required Object count}) => 'Publié (${count})',
			'catalog.tabs.draft' => ({required Object count}) => 'Brouillon (${count})',
			'catalog.tabs.archived' => ({required Object count}) => 'Archivé (${count})',
			'catalog.empty.no_archived' => 'Aucune plante archivée',
			'catalog.empty.no_draft' => 'Aucun brouillon',
			'catalog.empty.no_published' => 'Aucune plante publiée',
			'catalog.empty.no_description' => 'Aucune description',
			'catalog.card.title' => 'Plantes & boutures',
			'catalog.card.subtitle' => 'Mon catalogue de ce que j’ai à partager',
			'catalog.status.draft' => 'Brouillon',
			'catalog.status.published' => 'Publié',
			'catalog.status.archived' => 'Archivé',
			'catalog.detail.plant_env' => ({required Object env}) => 'plante ${env}',
			'catalog.detail.description' => 'Description',
			'catalog.detail.lighting' => 'lumière',
			'catalog.detail.watering' => 'arrosage',
			'catalog.detail.maintenance' => 'entretien',
			'catalog.detail.delete' => 'Supprimer',
			'catalog.detail.edit' => 'Modifier',
			'catalog.detail.delete_dialog.title' => 'Supprimer la plante',
			'catalog.detail.delete_dialog.content' => ({required Object name}) => 'Êtes-vous sûr de vouloir supprimer "${name}" ?\n\nCette action est irréversible.',
			'catalog.detail.delete_dialog.cancel' => 'Annuler',
			'catalog.detail.delete_error' => 'La suppression a échoué. Réessaie plus tard.',
			'catalog.edit.title' => 'Modifier ma plante',
			'catalog.edit.modifier_with_name' => ({required Object name}) => 'Modifier ${name}',
			'catalog.edit.save' => 'Enregistrer les modifications',
			'catalog.edit.upload_error' => ({required Object error}) => 'Erreur upload: ${error}',
			'catalog.edit.name.hint' => 'Nom de la plante',
			'catalog.edit.name.label' => 'Nom',
			'catalog.edit.description.title' => 'Ajouter une brève description',
			'catalog.edit.description.hint' => 'Description de la plante',
			'catalog.edit.description.label' => 'Description',
			'catalog.edit.description.max_length' => 'Maximum 150 caractères',
			'catalog.edit.family.title' => 'Sélectionner une ou des catégorie(s)',
			'catalog.edit.offer_type.title' => 'Que souhaitez-vous faire de votre plante ?',
			'catalog.edit.maintenance.title' => 'Sélectionner un niveau de difficulté',
			'catalog.edit.maintenance.low_subtitle' => 'Très résistante, peu d\'arrosage',
			'catalog.edit.maintenance.medium_subtitle' => 'Quelques soins réguliers',
			'catalog.edit.maintenance.high_subtitle' => 'Sensible, besoin de conditions spécifiques.',
			'catalog.edit.lighting.title' => 'Sélectionner le besoin en lumière',
			'catalog.edit.publish_label' => 'Publier la plante',
			'catalog.edit.watering.title' => 'Sélectionner le besoin en eau',
			'catalog.edit.environment.title' => 'Sélectionner une catégorie pour votre plante',
			'catalog.edit.image.title' => 'Sélectionner une à trois photos de votre plante',
			'catalog.wizard.title' => 'Ajouter une plante',
			'catalog.wizard.error_image' => 'Erreur lors de la sélection d’image.',
			'catalog.wizard.select_images' => 'Sélectionner des images',
			'catalog.wizard.image_count' => ({required Object index}) => 'Image ${index}',
			'catalog.wizard.required_field' => 'Ce champ est requis',
			'catalog.wizard.publish_label' => 'Publier la plante',
			'catalog.wizard.finish' => 'Terminer',
			'catalog.wizard.next' => 'Suivant',
			'catalog.wizard.quit_dialog.title' => 'Quitter sans enregistrer ?',
			'catalog.wizard.quit_dialog.content' => 'Les informations saisies seront perdues.',
			'catalog.wizard.quit_dialog.cancel' => 'Annuler',
			'catalog.wizard.quit_dialog.quit' => 'Quitter',
			'catalog.wizard.steps.name.title' => 'Nom de la plante',
			'catalog.wizard.steps.name.description' => 'Entrez le nom de la plante',
			'catalog.wizard.steps.name.label' => 'Nom',
			'catalog.wizard.steps.name.hint' => 'Nom',
			'catalog.wizard.steps.category.title' => 'Quel environnement ?',
			'catalog.wizard.steps.category.description' => 'Sélectionnez une catégorie',
			'catalog.wizard.steps.category.indoor' => 'Intérieur',
			'catalog.wizard.steps.category.outdoor' => 'Extérieur',
			'catalog.wizard.steps.family.title' => 'Choisir une famille',
			'catalog.wizard.steps.family.description' => 'Sélectionnez une ou des catégorie(s)',
			'catalog.wizard.steps.description.title' => 'Description',
			'catalog.wizard.steps.description.description' => 'Ajouter une brève description',
			'catalog.wizard.steps.description.label' => 'Description',
			'catalog.wizard.steps.description.hint' => 'Description',
			'catalog.wizard.steps.image.title' => 'Ajouter une photo',
			'catalog.wizard.steps.image.description' => 'Sélectionner une à trois photos de votre plante',
			'catalog.wizard.steps.watering.title' => 'Arrosage',
			'catalog.wizard.steps.watering.description' => 'Besoin en eau',
			'catalog.wizard.steps.watering.label' => 'Eau',
			'catalog.wizard.steps.watering.little' => 'Peu d\'eau',
			'catalog.wizard.steps.watering.regularly' => 'Régulier',
			'catalog.wizard.steps.lighting.title' => 'Lumière',
			'catalog.wizard.steps.lighting.description' => 'Besoin en lumière',
			'catalog.wizard.steps.lighting.label' => 'Lumière',
			'catalog.wizard.steps.lighting.sun' => 'Soleil',
			'catalog.wizard.steps.lighting.indirect' => 'Indirecte',
			'catalog.wizard.steps.lighting.shade' => 'Ombre',
			'catalog.wizard.steps.maintenance.title' => 'Entretien',
			'catalog.wizard.steps.maintenance.description' => 'Niveau de difficulté',
			'catalog.wizard.steps.maintenance.label' => 'Difficulté',
			'catalog.wizard.steps.maintenance.low' => 'Facile',
			'catalog.wizard.steps.maintenance.medium' => 'Moyen',
			'catalog.wizard.steps.maintenance.high' => 'Difficile',
			'catalog.wizard.steps.offer_type.title' => 'Offre',
			'catalog.wizard.steps.offer_type.description' => 'Que faire de votre plante ?',
			'catalog.wizard.steps.offer_type.donation' => 'Donation',
			'catalog.wizard.steps.offer_type.exchange' => 'Echange',
			'catalog.wizard.steps.publish.title' => 'Publication',
			'catalog.wizard.steps.publish.description' => 'Publier maintenant ?',
			'catalog.families.tropical' => 'Tropicale',
			'catalog.families.succulent' => 'Succulente',
			'catalog.families.aquatic' => 'Aquatique',
			'catalog.families.climbing' => 'Grimpante',
			'catalog.families.bonsai' => 'Bonsaï',
			'catalog.families.flower' => 'Fleurie',
			'catalog.families.aromatic' => 'Aromatique',
			'catalog.families.medical' => 'Médicinale',
			'catalog.families.carnivorous' => 'Carnivore',
			'catalog.enums.lighting.sun' => 'Soleil',
			'catalog.enums.lighting.indirect' => 'Indirecte',
			'catalog.enums.lighting.shade' => 'Ombre',
			'catalog.enums.environment.indoor' => 'Intérieur',
			'catalog.enums.environment.outdoor' => 'Extérieur',
			'catalog.enums.maintenance.low' => 'Facile',
			'catalog.enums.maintenance.medium' => 'Moyen',
			'catalog.enums.maintenance.high' => 'Difficile',
			'catalog.enums.watering.little' => 'Peu d\'eau',
			'catalog.enums.watering.regularly' => 'Régulier',
			'catalog.enums.offer_type.exchange' => 'Échange',
			'catalog.enums.offer_type.donation' => 'Donation',
			'catalog.sort.title' => 'Trier par',
			'catalog.sort.newest' => 'Plus récent',
			'catalog.sort.nameAsc' => 'Nom de la plante : A à Z',
			'catalog.sort.nameDesc' => 'Nom de la plante : Z à A',
			'catalog.sort.btn' => 'Appliquer',
			'chatPlant.screen.plant_unavailable' => 'Cette plante n\'est plus disponible.',
			'chatPlant.view.empty_messages' => 'Aucun message pour le moment.\nDémarrez la conversation.',
			'chatPlant.view.blocked_user_banner' => 'Vous avez bloqué cet utilisateur',
			'chatPlant.view.blocked_by_other_banner' => 'Vous ne pouvez plus écrire à cet utilisateur',
			'chatPlant.view.unblock_btn' => 'Débloquer',
			'chatPlant.view.unblock_dialog.title' => 'Débloquer cet utilisateur ?',
			'chatPlant.view.unblock_dialog.content' => 'Cette personne pourra à nouveau vous envoyer des messages.',
			'chatPlant.view.unblock_dialog.confirm' => 'Débloquer',
			'chatPlant.view.status.exchange_accepted_waiting' => 'L\'échange est accepté ! En attente de la rencontre.',
			'chatPlant.view.status.donation_accepted_waiting' => 'La donation est acceptée ! En attente de la rencontre.',
			'chatPlant.view.input_hint' => 'Écrire un message…',
			'chatPlant.menu.see_profile' => 'Voir le profil',
			'chatPlant.menu.report' => 'Signaler',
			'chatPlant.menu.unblock' => 'Débloquer',
			'chatPlant.menu.block' => 'Bloquer',
			'chatPlant.menu.clear_chat' => 'Effacer la conversation',
			'chatPlant.menu.delete' => 'Supprimer',
			'chatPlant.menu.delete_dialog.title' => 'Effacer la conversation',
			'chatPlant.menu.delete_dialog.content' => 'Elle sera supprimée uniquement pour vous.',
			'chatPlant.menu.report_dialog.title' => 'Signaler',
			'chatPlant.menu.report_dialog.content' => 'Cette conversation sera transmise à l\'équipe PlantMatch pour examen. Merci de nous aider à maintenir une communauté saine.',
			'chatPlant.menu.block_dialog.title' => 'Bloquer cet utilisateur ?',
			'chatPlant.menu.block_dialog.content' => 'Cette personne ne pourra plus vous envoyer de messages ni voir votre profil.',
			'chatPlant.menu.block_dialog.warning_active_transaction' => 'Attention : un échange est en cours. Bloquer cet utilisateur notifiera l\'équipe PlantMatch et aucun point ne sera distribué.',
			'chatPlant.actions.accept' => 'Accepter',
			'chatPlant.actions.refuse' => 'Refuser',
			'chatPlant.actions.cancel' => 'Annuler',
			'chatPlant.actions.confirm' => 'Confirmer',
			'chatPlant.actions.complete_label' => ({required Object label}) => 'Marquer ${label} comme terminée',
			'chatPlant.actions.propose_exchange_btn' => 'Proposer un échange',
			'chatPlant.actions.labels.exchange' => 'l\'échange',
			'chatPlant.actions.labels.donation' => 'la donation',
			'chatPlant.validation.title' => 'Confirmation de réception',
			'chatPlant.validation.description' => 'Saisissez le code à 6 chiffres donné par le propriétaire.',
			'chatPlant.validation.hint' => '000000',
			'chatPlant.validation.confirm_btn' => 'Confirmer la réception',
			'chatPlant.display_code.ready_title' => 'L\'échange est prêt !',
			'chatPlant.display_code.ready_subtitle' => 'Générez le code une fois que vous êtes avec la personne.',
			'chatPlant.display_code.generate_btn' => 'Générer le code de remise',
			'chatPlant.display_code.code_title' => 'Code de confirmation',
			'chatPlant.display_code.code_subtitle' => 'Montrez ce code au receveur pour finaliser l\'échange.',
			'chatPlant.display_code.regenerate_btn' => 'Générer un nouveau code',
			'chatPlant.plant_card.proposed_plant' => 'Plante proposée',
			'chatPlant.plant_card.exchange_proposal' => 'Proposition d\'échange',
			'chatPlant.plant_card.view_detail' => 'Voir le détail',
			'chatPlant.plant_card.error_loading' => 'Impossible de charger les détails',
			'chatPlant.info_bar.exchange.pending' => 'Une demande d\'échange est en attente de réponse',
			'chatPlant.info_bar.exchange.accepted' => 'Échange accepté 🎉',
			'chatPlant.info_bar.exchange.rejected' => 'Échange refusé',
			'chatPlant.info_bar.exchange.completed' => 'Échange terminé ✅',
			'chatPlant.info_bar.donation.pending' => 'Une demande de donation est en attente de réponse',
			'chatPlant.info_bar.donation.accepted' => 'Donation acceptée 🎉',
			'chatPlant.info_bar.donation.rejected' => 'Donation refusée',
			'chatPlant.info_bar.donation.completed' => 'Donation terminée ✅',
			'common.notConnected' => 'Utilisateur non connecté',
			'exchange.screen.loading' => 'Chargement...',
			'exchange.screen.picking_title' => 'Choisir une plante à échanger',
			'exchange.screen.confirm_title' => 'Confirmer l\'échange',
			'exchange.screen.success_title' => 'Succès',
			'exchange.screen.success_message' => 'Échange proposé avec succès !',
			'exchange.screen.error_title' => 'Erreur',
			'exchange.confirmation.offered_plant_title' => 'Tu proposes cette plante',
			'exchange.confirmation.target_plant_title' => 'Contre sa plante',
			'exchange.confirmation.confirm_btn' => 'Confirmer l\'échange',
			'exchange.confirmation.change_plant_btn' => 'Choisir une autre plante',
			'exchange.picker.no_plants' => 'Tu n\'as pas encore de plantes à échanger',
			'exchange.picker.no_plants_description' => 'Ajoute une plante proposée à l\'échange pour pouvoir la proposer en retour.',
			'exchange.picker.add_plant' => 'Ajouter une plante',
			'exchange.picker.subtitle' => 'Sélectionne la plante que tu veux proposer en échange.',
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
			'home.header.greeting' => ({required Object name}) => 'Hello, ${name}',
			'home.header.subtitle' => 'Prêt à échanger ou donner\nde nouvelles plantes ?',
			'home.around_me.title' => 'Autour de toi',
			'home.around_me.see_on_map' => 'Voir sur la carte',
			'home.around_me.no_location' => 'Activez la géolocalisation pour voir les plantes autour de vous',
			'home.around_me.empty' => 'Aucune plante trouvée à proximité',
			'home.card.exchange' => 'Échange',
			'home.card.donation' => 'Donation',
			'home.card.distance_owner' => ({required Object distance, required Object name}) => '${distance} km • ${name}',
			'home.recommendation.title' => 'Tes suggestions personnalisées',
			'home.recommendation.adjust_preferences' => 'Ajuster mes préférences',
			'home.recommendation.empty' => 'Aucune plante ne correspond à tes préférences actuelles.',
			'home.recommendation.adjust_filters' => 'Ajuster les filtres',
			'home.recommendation.banner_title' => 'Trouve ta plante idéale',
			'home.recommendation.banner_subtitle' => 'Réponds à quelques questions et nous te suggérons des plantes !',
			'home.recent_activity.title' => 'Activité récente',
			'home.recent_activity.see_all' => 'Voir tout',
			'home.recent_activity.empty' => 'Aucune activité récente',
			'legalInformation.screen.title' => 'Informations juridiques',
			'legalInformation.items.privacy_policy' => 'Politique de confidentialité',
			'legalInformation.items.terms' => 'Conditions d\'utilisation',
			'legalInformation.items.legal_notice' => 'Mentions légales',
			'level.screen.title' => 'Mes badges',
			'level.screen.my_level' => 'Mon niveau',
			'level.screen.my_badges' => 'Mes badges',
			'level.header.points' => 'Dons & Échanges',
			'level.header.level' => ({required Object level}) => 'Niveau ${level}',
			'level.cards.challenges.title' => 'Défis et récompenses',
			'level.cards.challenges.description' => 'Participer à des défis, gagner des récompenses',
			'level.cards.gifts.title' => 'Choisir mes cadeaux',
			'level.cards.gifts.description' => 'Transformer vos dons en feuilles bonus',
			'level.cards.discover' => 'Découvrir',
			'level.progress.level_prefix' => 'Niveau ',
			'level.progress.max_level' => 'Niveau max',
			'level.progress.pts_suffix' => ' dons/échanges',
			'level.detail.level_title' => ({required Object level}) => 'Niveau ${level}',
			'level.detail.conditions' => 'Conditions : ',
			'level.detail.description' => 'Description : ',
			'level.detail.required_points' => 'Dons/Échanges requis : ',
			'level.detail.rewarded_actions_title' => 'Récompense du palier :',
			'level.detail.points' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n, one: ' ${n} don ou échange', other: ' ${n} dons ou échanges', ), 
			'level.detail.bonus_leaves' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n, one: '+${n} feuille bonus', other: '+${n} feuilles bonus', ), 
			'level.detail.welcome_pack' => 'Pack de bienvenue (5 feuilles)',
			'level.detail.unlimited_contacts' => 'Contacts illimités, sans dépenser de feuilles',
			'level.levels.k1.condition' => 'Inscription sur PlantMatch.',
			'level.levels.k1.description' => 'Bienvenue dans la communauté ! Tu viens de planter ta première graine.',
			'level.levels.k1.actions.registration' => 'Inscription',
			'level.levels.k1.actions.first_plant' => 'Pack de bienvenue (5 feuilles)',
			'level.levels.k2.condition' => 'Réaliser 2 dons ou échanges confirmés.',
			'level.levels.k2.description' => 'Tu commences à échanger et donner tes plantes avec la communauté !',
			'level.levels.k2.actions.first_exchange' => '2 dons ou échanges réussis (+3 feuilles bonus)',
			'level.levels.k3.condition' => 'Réaliser 5 dons ou échanges confirmés.',
			'level.levels.k3.description' => 'Un cultivateur actif qui partage régulièrement ses boutures !',
			'level.levels.k3.actions.exchange' => '5 dons ou échanges réussis (+5 feuilles bonus)',
			'level.levels.k4.condition' => 'Réaliser 10 dons ou échanges confirmés.',
			'level.levels.k4.description' => 'Un jardinier confirmé réputé pour sa générosité !',
			'level.levels.k4.actions.exchange' => '10 dons ou échanges réussis (+8 feuilles bonus)',
			'level.levels.k5.condition' => 'Réaliser 25 dons ou échanges confirmés.',
			'level.levels.k5.description' => 'Expert des plantes de la communauté PlantMatch !',
			'level.levels.k5.actions.exchange' => '25 dons ou échanges réussis (+12 feuilles bonus)',
			'level.levels.k6.condition' => 'Réaliser 50 dons ou échanges confirmés.',
			'level.levels.k6.description' => 'Maître du jardinage d\'exception !',
			'level.levels.k6.actions.exchange' => '50 dons ou échanges réussis (+20 feuilles bonus)',
			'level.levels.k7.condition' => 'Réaliser 100 dons ou échanges confirmés.',
			'level.levels.k7.description' => 'Gardien de la nature légendaire de PlantMatch !',
			'level.levels.k7.actions.exchange' => '100 dons ou échanges réussis (Feuilles illimitées)',
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
			'levelAwarded.rewards.default_title' => 'Félicitations !',
			'levelAwarded.rewards.default_description' => 'Vous venez d\'obtenir des feuilles bonus pour vos interactions.',
			'levelAwarded.rewards.plant_given' => 'Plante donnée !',
			'levelAwarded.rewards.plant_given_description' => 'Merci d\'avoir fait vivre la communauté. Voici vos feuilles pour continuer vos adoptions.',
			'levelAwarded.rewards.referral' => 'Code de parrainage validé !',
			'levelAwarded.rewards.level_up_title' => ({required Object level}) => 'Niveau ${level} atteint !',
			'levelAwarded.rewards.level_up_description' => ({required Object name}) => 'Vous êtes maintenant ${name}. Voici vos feuilles bonus pour continuer vos adoptions.',
			'levelAwarded.rewards.leaves' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(n, one: '+${n} feuille', other: '+${n} feuilles', ), 
			'message.screen.title' => 'Mes messages',
			'message.empty.title' => 'Aucune conversation',
			'message.empty.subtitle' => 'Commencez à discuter avec vos futurs partenaires d\'échange !',
			'onboarding.items.catalog.title' => 'Catalogue de Plantes\nPersonnalisé',
			'onboarding.items.catalog.description' => 'Créez et gérez votre propre collection de plantes. Ajoutez des photos, des descriptions, et recevez des rappels pour l’entretien de vos plantes.',
			'onboarding.items.map.title' => 'Échange de Plantes\net Boutures',
			'onboarding.items.map.description' => 'Découvrez et échangez des plantes ou boutures avec d\'autres passionnés près de chez vous. Utilisez la géolocalisation pour trouver facilement des échanges.',
			'onboarding.items.chat.title' => 'Messagerie\nIntégrée',
			'onboarding.items.chat.description' => 'Communiquez facilement avec d\'autres utilisateurs pour organiser des échanges de plantes, poser des questions, ou simplement partager des conseils.',
			'onboarding.items.advice.title' => 'Aide et Conseils\nCommunautaires',
			'onboarding.items.advice.description' => 'Posez des questions et obtenez des conseils personnalisés de la part de la communauté pour mieux prendre soin de vos plantes ou résoudre des problèmes.',
			'onboarding.skip' => 'Passer',
			'onboarding.register' => 'Créer un compte',
			'onboarding.login' => 'Se connecter',
			'personalInformation.screen.title' => 'Informations personnelles',
			'personalInformation.detail.title' => 'Détail de mon profil',
			'personalInformation.detail.pseudo' => 'Pseudo d\'affichage',
			'personalInformation.detail.birthday' => 'Date d\'anniversaire',
			'personalInformation.detail.bio' => 'Bio',
			'personalInformation.detail.location' => 'Localisation',
			'personalInformation.detail.empty_field' => 'À renseigner',
			'personalInformation.detail.edit_button' => 'Modifier mon profil',
			'personalInformation.detail.clear.title' => ({required Object field}) => 'Effacer « ${field} » ?',
			'personalInformation.detail.clear.content' => 'Cette information sera supprimée de votre profil.',
			'personalInformation.detail.clear.confirm' => 'Effacer',
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
			'personalInformation.wizard.common.skip' => 'Passer',
			'personalInformation.wizard.common.finish' => 'Terminer',
			'personalInformation.wizard.common.save' => 'Enregistrer',
			'personalInformation.wizard.common.update_location' => 'Mettre à jour ma position',
			'personalInformation.wizard.referral.title' => 'Code de parrainage',
			'personalInformation.wizard.referral.description' => 'Si un ami vous a parrainé, saisissez son code pour gagner tous les deux 3 feuilles supplémentaires !',
			'personalInformation.wizard.referral.hint' => 'Ex : PM-XYZ12',
			'personalInformation.wizard.referral.label' => 'Code de parrainage (Optionnel)',
			'personalInformation.wizard.leave.title' => 'Quitter sans enregistrer ?',
			'personalInformation.wizard.leave.content' => 'Vos modifications ne seront pas enregistrées.',
			'personalInformation.wizard.leave.confirm' => 'Quitter',
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
			'profil.navigation.navigation_title.essential' => 'Les essentiels',
			'profil.navigation.navigation_title.personalization' => 'Personnalisation',
			'profil.navigation.navigation_title.plant_match' => 'PlantMatch',
			'profil.cards.catalog.title' => 'Plantes & Boutures',
			'profil.cards.catalog.description' => 'Mon catalogue de ce que j’ai à partager',
			'profil.cards.favorites.title' => 'Mes\nFavoris',
			'profil.cards.favorites.description' => 'Mes plantes et profils préférés',
			'profil.cards.awards.title' => 'Badges & Récompenses',
			'profil.cards.awards.description' => 'Mes badges et mon niveau',
			'profil.premium.title' => 'PlantMatch Premium',
			'profil.premium.description' => 'Profiter des avantages premium avec des fonctionnalités exclusives.',
			'profil.premium.btn' => 'Découvrir',
			'recentActivity.screen.title' => 'Activité récente',
			'recentActivity.empty.message' => 'Aucune activité récente',
			'recentActivity.tile.added_plant' => ' a ajouté une plante',
			'recentActivity.tile.minutes' => ({required Object count}) => '${count} min',
			'recentActivity.tile.hours' => ({required Object count}) => '${count} h',
			'recentActivity.tile.days' => ({required Object count}) => '${count} j',
			'user.bio.empty' => 'Pas encore de description...',
			_ => null,
		} ?? switch (path) {
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
			'user.detail_plant.description_title' => 'Description',
			'user.detail_plant.key_info_title' => 'Les informations clés',
			'user.detail_plant.no_leaves.title' => 'Plus de feuilles disponibles',
			'user.detail_plant.no_leaves.content' => 'Vous n\'avez plus de feuilles pour contacter un donneur.\n\nDonnez ou échangez une plante (+2 feuilles) ou parrainez un ami (+3 feuilles) pour continuer !',
			'user.detail_plant.no_leaves.ok' => 'D\'accord',
			'user.detail_plant.share.donation' => 'donne',
			'user.detail_plant.share.exchange' => 'échange',
			'user.detail_plant.share.text' => ({required Object type, required Object name, required Object description}) => 'Regarde cette plante sur PlantMatch !\n\nJe ${type} une magnifique *${name}*.\n"${description}"\n\nTélécharge l\'application PlantMatch pour l\'adopter ou l\'échanger autour de toi ! 🌿',
			'user.filters.all' => 'Tous',
			'user.filters.donation' => 'Donations',
			'user.filters.exchange' => 'Échanges',
			'user.filters.outdoor' => 'Extérieur',
			'user.filters.indoor' => 'Intérieur',
			'widgets.navigation.explorer' => 'Explorer',
			'widgets.navigation.aroundMe' => 'À proximité',
			'widgets.navigation.add' => 'Ajouter',
			'widgets.navigation.messages' => 'Messages',
			'widgets.navigation.profile' => 'Mon profil',
			'widgets.error.back' => 'Retour',
			'widgets.error.retry' => 'Essayer à nouveau',
			'widgets.error.reconnect' => 'Se reconnecter',
			'widgets.error.network.title' => 'Pas de connexion',
			'widgets.error.network.message' => 'Vérifiez votre connexion internet puis réessayez.',
			'widgets.error.server.title' => 'Service momentanément indisponible',
			'widgets.error.server.message' => 'Nos serveurs rencontrent un souci. Réessayez dans quelques instants.',
			'widgets.error.permission.title' => 'Accès refusé',
			'widgets.error.permission.message' => 'Vous n\'avez pas les droits pour accéder à ce contenu.',
			'widgets.error.session.title' => 'Session expirée',
			'widgets.error.session.message' => 'Reconnectez-vous pour continuer.',
			'widgets.error.notFound.title' => 'Contenu introuvable',
			'widgets.error.notFound.message' => 'Ce contenu n\'existe plus ou a été supprimé.',
			'widgets.error.location.title' => 'Localisation impossible',
			'widgets.error.location.disabled' => 'La localisation est désactivée. Activez-la dans les réglages de votre téléphone.',
			'widgets.error.location.denied' => 'PlantMatch n\'a pas accès à votre position. Autorisez la localisation dans les réglages.',
			'widgets.error.location.unavailable' => 'Impossible d\'obtenir votre position pour le moment. Réessayez dans un instant.',
			'widgets.error.validation.title' => 'Action impossible',
			'widgets.error.unexpected.title' => 'Oups ! une erreur est survenue',
			'widgets.error.unexpected.message' => 'Quelque chose s\'est mal passé. Réessayez dans un instant.',
			'widgets.error.auth.title' => 'Connexion impossible',
			'widgets.error.auth.invalidCredentials' => 'L\'email ou le mot de passe est incorrect.',
			'widgets.error.auth.invalidEmail' => 'L\'adresse email n\'est pas valide.',
			'widgets.error.auth.userDisabled' => 'Ce compte a été désactivé.',
			'widgets.error.auth.emailAlreadyInUse' => 'Un compte existe déjà avec cette adresse email.',
			'widgets.error.auth.accountExistsWithDifferentCredential' => 'Un compte existe déjà avec cette adresse email via un autre mode de connexion.',
			'widgets.error.auth.weakPassword' => 'Le mot de passe est trop faible.',
			'widgets.error.auth.tooManyRequests' => 'Trop de tentatives. Patientez quelques minutes avant de réessayer.',
			'widgets.error.auth.cancelled' => 'La connexion a été annulée.',
			'widgets.error.auth.provider' => 'La connexion avec ce service a échoué. Réessayez.',
			'widgets.error.auth.emailAlreadyVerified' => 'Votre adresse email est déjà vérifiée.',
			'widgets.error.auth.emailNotVerified' => 'Votre adresse email n\'est pas encore vérifiée.',
			'widgets.error.auth.profileMissing' => 'Votre profil n\'est pas encore finalisé.',
			'widgets.error.auth.noEmail' => 'Aucune adresse e-mail n\'est associée à votre compte.',
			'widgets.common.viewMore' => 'En voir +',
			'widgets.common.cancel' => 'Annuler',
			'widgets.common.confirm' => 'Confirmer',
			'widgets.date.today' => 'Aujourd\'hui',
			'widgets.date.yesterday' => 'Hier',
			'widgets.date.days.monday' => 'Lundi',
			'widgets.date.days.tuesday' => 'Mardi',
			'widgets.date.days.wednesday' => 'Mercredi',
			'widgets.date.days.thursday' => 'Jeudi',
			'widgets.date.days.friday' => 'Vendredi',
			'widgets.date.days.saturday' => 'Samedi',
			'widgets.date.days.sunday' => 'Dimanche',
			'widgets.notifications.later' => 'Plus tard',
			'widgets.notifications.prompt.title' => 'Ne manquez aucune réponse',
			'widgets.notifications.prompt.content' => 'Activez les notifications pour être prévenu dès que vous recevez un nouveau message.',
			'widgets.notifications.prompt.confirm' => 'Activer',
			_ => null,
		};
	}
}
