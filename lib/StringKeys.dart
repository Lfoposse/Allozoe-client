import 'package:flutter/material.dart';

import 'translations.dart';

// retourne une chaine de caratere a partir de la cle fournit dans la langue preferee du telephone
String getLocaleText(
    {@required BuildContext context, @required String strinKey}) {
  return Translations.of(context).text(strinKey);
}

class StringKeys {
  // Liste de toutes les cles des chaines de caracteres ici
  // Chaine lié à la page de chargement
  static final String LOADING = "LOADING";
  static final String CATEGORY_SEARCH = "CATEGORY_SEARCH";
  static final String CATEGORY_DIFF_CATEGORY = "CATEGORY_DIFF_CATEGORY";

  // chaines lies a la page de login
  static final String LOGIN_PAGE_TITLE = "LOGIN_PAGE_TITLE";
  static final String WELCOME_TEXT = "WELCOME_TEXT";
  static final String EMAIL_HINT = "EMAIL_HINT";
  static final String PASSWORD_HINT = "PASSWORD_HINT";
  static final String LOGIN_BTN_TITLE = "LOGIN_BTN_TITLE";
  static final String NOT_HAVE_ACCOUNT = "NOT_HAVE_ACCOUNT";
  static final String SIGN_UP = "SIGN_UP";
  static final String FORGOT_PASSWORD = "FORGOT_PASSWORD";
  static final String CANCEL_BTN = "CANCEL_BTN";
  static final String ACTIVATE_BTN = "ACTIVATE_BTN";
  static final String RETRY_BTN = "RETRY_BTN";

  static final String ERROR_ENTER_ALL_CREDENTIALS =
      "ERROR_ENTER_ALL_CREDENTIALS";
  static final String ERROR_INVALID_EMAIL = "ERROR_INVALID_EMAIL";
  static final String ERROR_WRONG_CREDENTIALS = "ERROR_WRONG_CREDENTIALS";
  static final String ERROR_CONNECTION_FAILED = "ERROR_CONNECTION_FAILED";
  static final String ERROR_CONNECTION_FAILED_TITLE =
      "ERROR_CONNECTION_FAILED_TITLE";
  static final String ERROR_ACCOUNT_NOT_ACTIVATED_TITLE =
      "ERROR_ACCOUNT_NOT_ACTIVATED_TITLE";
  static final String ERROR_ACCOUNT_NOT_ACTIVATED_MSG =
      "ERROR_ACCOUNT_NOT_ACTIVATED_MSG";

  // chaines lies a la page d'inscription
  static final String SIGNUP_PAGE_TITLE = "SIGNUP_PAGE_TITLE";
  static final String NAME_HINT = "NAME_HINT";
  static final String SURNAME_HINT = "SURNAME_HINT";
  static final String SIGNUP_EMAIL_HINT = "SIGNUP_EMAIL_HINT";
  static final String SIGNUP_PASSWORD_HINT = "SIGNUP_PASSWORD_HINT";
  static final String PHONE_HINT = "PHONE_HINT";

  static final String PHONE_NUMBER = "PHONE_NUMBER";
  static final String PAY = "PAY";

  static final String CONFIDENTIALITE_BEGIN = "CONFIDENTIALITE_BEGIN";
  static final String CONDITIONS_GENERALES = "CONDITIONS_GENERALES";
  static final String AND = "AND";
  static final String CONFIDENTIALITE = "CONFIDENTIALITE";

  static final String ERROR_FILL_ALL_GAPS = "ERROR_FILL_ALL_GAPS";
  static final String ERROR_ACCOUNT_ALREADY_EXISTS =
      "ERROR_ACCOUNT_ALREADY_EXISTS";

  // chaines lies a la page d'inscription
  static final String RECOVERY_PAGE_TITLE = "RECOVERY_PAGE_TITLE";
  static final String RECOVERY_DESCRIPTION_TEXT = "RECOVERY_DESCRIPTION_TEXT";
  static final String NEXT_BTN = "NEXT_BTN";

  static final String ERROR_UNKOWN_EMAIL = "UNKOWN_EMAIL";
  static final String ERROR_ENTER_EMAIL = "ENTER_EMAIL";

  // chaines lies a la page de confirmation
  static final String CONFIRMATION_PAGE_TITLE = "CONFIRMATION_PAGE_TITLE";
  static final String CONFIRMATION_DESCRIPTION_TEXT =
      "CONFIRMATION_DESCRIPTION_TEXT";
  static final String VALIDATE_BTN = "VALIDATE_BTN";

  static final String ERROR_WRONG_CODE = "ERROR_WRONG_CODE";
  static final String ERROR_INCOMPLETE_CODE = "ERROR_INCOMPLETE_CODE";

  // chaines lies a la page de redefinition du mot de passe
  static final String RESET_PASS_DESCRIPTION_TEXT =
      "RESET_PASS_DESCRIPTION_TEXT";
  static final String NEW_PASSWORD_HINT = "NEW_PASSWORD_HINT";
  static final String CONFIRM_PASSWORD_HINT = "CONFIRM_PASSWORD_HINT";
  static final String UPDATE_BTN = "UPDATE_BTN";
  static final String RESET_SUCCESS_TITLE = "RESET_SUCCESS_TITLE";
  static final String RESET_SUCCESS_MESSAGE = "RESET_SUCCESS_MESSAGE";
  static final String OK_BTN = "OK_BTN";

  static final String ERROR_PASS_AND_CONFIRM_NOT_MATCH =
      "ERROR_PASS_AND_CONFIRM_NOT_MATCH";
  static final String ERROR_OCCURED = "ERROR_OCCURED";

  // chaines lies a la page de d'accueil
  static final String ACCUEIL_TITLE = "ACCUEIL_TITLE";
  static final String SEARCH_TITLE = "SEARCH_TITLE";
  static final String CART_TITLE = "CART_TITLE";
  static final String COMMANDES_TITLE = "COMMANDES_TITLE";
  static final String PROFIL_TITLE = "PROFIL_TITLE";

  // chaines lies a la page de d'accueil
  static final String RESTAURANTS_NEARBY_TITLE = "RESTAURANTS_NEARBY_TITLE";
  static final String RESTAURANTS_NEARBY_NOT_FOUND =
      "RESTAURANTS_NEARBY_NOT_FOUND";

  // chianes lier au panier

  static final String PANIER_COMPLEMENT = "PANIER_COMPLEMENT";
  static final String PANIER_PRODUCT = "PANIER_PRODUCT";
  static final String PANIER_OFFERT = "PANIER_OFFERT";
  static final String PANIER_SUPPRIMER = "PANIER_SUPPRIMER";
  static final String PANIER_SUB_TOTAL = "PANIER_SUB_TOTAL";
  static final String PANIER_FRAIS_LIVRAISON = "PANIER_FRAIS_LIVRAISON";
  static final String PANIER_TOTAL = "PANIER_TOTAL";
  static final String PANIER_VIDE = "PANIER_VIDE";
  static final String PANIER_MON_PANIER = "PANIER_MON_PANIER";
  static final String PANIER_ARTICLES = "PANIER_ARTICLES";
  static final String PANIER_MIN_PRICE_PANIER = "PANIER_MIN_PRICE_PANIER";
  static final String PANIER_FINALISER = "PANIER_FINALISER";

  static final String COMMANDE_REF = "COMMANDE_REF";
  static final String COMMANDE_TOTAL = "COMMANDE_TOTAL";
  static final String COMMANDE_NOTE = "COMMANDE_NOTE";
  static final String COMMANDE_RECHERCHER = "COMMANDE_RECHERCHER";
  static final String COMMANDE_NOT_FOUND = "COMMANDE_NOT_FOUND";
  static final String COMMANDE_VIDE = "COMMANDE_VIDE";

  // chaine profile

  static final String PROFILE_DECONNEXION = "PROFILE_DECONNEXION";
  static final String PROFILE_ASK_DECONNECTION = "PROFILE_ASK_DECONNECTION";
  static final String PROFILE_ANNULER = "PROFILE_ANNULER";
  static final String PROFILE_OK = "PROFILE_OK";
  static final String PROFILE_MODIFIER = "PROFILE_MODIFIER";
  static final String PROFILE_UPDATE_PASSWORD = "PROFILE_UPDATE_PASSWORD";
  static final String PROFILE_MY_PROFILE = "PROFILE_MY_PROFILE";
  static final String PROFILE_PAYMENT_MODE = "PROFILE_PAYMENT_MODE";
  static final String PROFILE_ERROR_FIELD_REQUIREMENT =
      "PROFILE_ERROR_FIELD_REQUIREMENT";
  static final String PROFILE_ERROR_PASSWORD_DONT_MATCH =
      "PROFILE_ERROR_PASSWORD_DONT_MATCH";
  static final String PROFILE_NEW_PASSWORD = "PROFILE_NEW_PASSWORD";
  static final String PROFILE_CONFIRME_PASSWORD = "PROFILE_CONFIRME_PASSWORD";
  static final String PROFILE_CONNECTION_ERROR = "PROFILE_CONNECTION_ERROR";
  static final String PROFILE_ERROR_OCCURED = "PROFILE_ERROR_OCCURED";
  static final String PROFILE_SUCCES = "PROFILE_SUCCES";
  static final String PROFILE_PASSWORD_UPDATE_SUCCES =
      "PROFILE_PASSWORD_UPDATE_SUCCES";
  static final String PROFILE_ACCOUNT_INFO = "PROFILE_ACCOUNT_INFO";
  static final String PROFILE_ACCOUNT_ENREGISTRER =
      "PROFILE_ACCOUNT_ENREGISTRER";
  static final String PROFILE_NUM_CARTE = "PROFILE_NUM_CARTE";
  static final String PROFILE_CODE = "PROFILE_CODE";

  // other chaine

  static final String DELIVER = "DELIVER";
  static final String LIVRAISON = "LIVRAISON";
  static final String UNKNOW_CATEGORY = "UNKNOW_CATEGORY";
  static final String PRODUIT_NO_DESCRIPTION = "PRODUIT_NO_DESCRIPTION";
  static final String AVERTISSEMENT = "AVERTISSEMENT";
  static final String DELIVERY_ADDRESS_REQUIRED = "DELIVERY_ADDRESS_REQUIRED";

  static final String STATUS_INCONNU = "STATUS_INCONNU";
  static final String STATUS_PENDING = "STATUS_PENDING";
  static final String STATUS_APPROUVED = "STATUS_APPROUVED";
  static final String STATUS_REJETED = "STATUS_REJETED";
  static final String STATUS_DELIVER = "STATUS_DELIVER";
  static final String STATUS_PAY = "STATUS_PAY";
  static final String STATUS_SHIPING = "STATUS_SHIPING";
  static final String STATUS_PREPARING = "STATUS_PREPARING";

  // chaine card payment

  static final String CARD_BANK = "CARD_BANK";
  static final String CARD_TICKET = "CARD_TICKET";
  static final String CARD_AMOUNT_INVALIDE = "CARD_AMOUNT_INVALIDE";
  static final String CARD_TICKET_REQUIRE = "CARD_TICKET_REQUIRE";
  static final String CARD_TICKET_LOW = "CARD_TICKET_LOW";
  static final String CARD_TICKET_MIN = "CARD_TICKET_MIN";
  static final String CARD_TICKET_DEL_AVERT = "CARD_TICKET_DEL_AVERT";
  static final String CARD_ACCOUNT_UNKNOW = "CARD_ACCOUNT_UNKNOW";
  static final String CARD_NO_CARD_FOUND = "CARD_NO_CARD_FOUND";
  static final String CARD_SELECT_CARD = "CARD_SELECT_CARD";
  static final String CARD_YOUR_CARD = "CARD_YOUR_CARD";
  static final String CARD_ANOTHER_CARD = "CARD_ANOTHER_CARD";
  static final String CARD_ADD_CARD = "CARD_ADD_CARD";
  static final String CARD_TICKET_AMOUNT_CARD = "CARD_TICKET_AMOUNT_CARD";
  static final String CARD_TICKET_AMOUNT = "CARD_TICKET_AMOUNT";
  static final String CARD_AMOUNT_PAY = "CARD_AMOUNT_PAY";
  static final String CARD_PAYMENT_ERROR = "CARD_PAYMENT_ERROR";
  static final String CARD_PAYMENT_SUCCESS = "CARD_PAYMENT_SUCCESS";
  static final String CARD_BTN_PAY = "CARD_BTN_PAY";

  // chaine note

  static final String COMMANDE_POURBOIRE = "COMMANDE_POURBOIRE";
  static final String COMMANDE_NOTE_RESTAURANT = "COMMANDE_NOTE_RESTAURANT";
  static final String COMMANDE_NOTE_LIVREUR = "COMMANDE_NOTE_LIVREUR";
  static final String COMMANDE_NOTE_ENVOYER = "COMMANDE_NOTE_ENVOYER";
  static final String COMMANDE_NOTE_SUIVANT = "COMMANDE_NOTE_SUIVANT";
  static final String COMMANDE_NOTE_OK = "COMMANDE_NOTE_OK";
  static final String CHERCHER_ICI = "CHERCHER_ICI";
  static final String PRICE = "PRICE";
  static final String QUANTITE = "QUANTITE";

  static final String AVERTISEMENT_CHANGE_RESTAURANT =
      "AVERTISEMENT_CHANGE_RESTAURANT";
  static final String AJOUTER_PANIER = "AJOUTER_PANIER";
  static final String AJOUTER_PANIER_BTN = "AJOUTER_PANIER_BTN";
  static final String RETIRER_PANIER_BTN = "RETIRER_PANIER_BTN";

  static final String ARTICLE_COMMANDE = "ARTICLE_COMMANDE";
  static final String FORMAT_INTERNATIONAL = "FORMAT_INTERNATIONAL";
  static final String DELIVERY_ADDRESS = "DELIVERY_ADDRESS";
  static final String ADDRESS = "ADDRESS";
  static final String CONTACT = "CONTACT";
  static final String DETAIL_COMMANDE = "DETAIL_COMMANDE";
  static final String RESTAURANT_INFO = "RESTAURANT_INFO";
  static final String LANGUE = 'LANGUE';
  static final String CARD_BTN_DELETED = 'CARD_BTN_DELETED';
  static final String CARD_ERROR_DELETED = 'CARD_ERROR_DELETED';
  static final String ADD_NOTE = "ADD_NOTE";
  static final String DELIVERY_HOME = "DELIVERY_HOME";
  static final String DELIVERY_ROAD = "DELIVERY_ROAD";
  static final String VILLE = "VILLE";
  static final String PRODUIT_NO_FOUND = "PRODUIT_NO_FOUND";
}
