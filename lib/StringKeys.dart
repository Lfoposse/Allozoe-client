import 'package:flutter/material.dart';
import 'translations.dart';


// retourne une chaine de caratere a partir de la cle fournit dans la langue preferee du telephone
String getLocaleText({@required BuildContext context, @required String strinKey}){
  return Translations.of(context).text(strinKey);
}

class StringKeys{

  // Liste de toutes les cles des chaines de caracteres ici

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

  static final String ERROR_ENTER_ALL_CREDENTIALS = "ERROR_ENTER_ALL_CREDENTIALS";
  static final String ERROR_INVALID_EMAIL = "ERROR_INVALID_EMAIL";
  static final String ERROR_WRONG_CREDENTIALS = "ERROR_WRONG_CREDENTIALS";
  static final String ERROR_CONNECTION_FAILED = "ERROR_CONNECTION_FAILED";
  static final String ERROR_ACCOUNT_NOT_ACTIVATED_TITLE = "ERROR_ACCOUNT_NOT_ACTIVATED_TITLE";
  static final String ERROR_ACCOUNT_NOT_ACTIVATED_MSG = "ERROR_ACCOUNT_NOT_ACTIVATED_MSG";



  // chaines lies a la page d'inscription
  static final String SIGNUP_PAGE_TITLE = "SIGNUP_PAGE_TITLE";
  static final String NAME_HINT = "NAME_HINT";
  static final String SURNAME_HINT = "SURNAME_HINT";
  static final String SIGNUP_EMAIL_HINT = "SIGNUP_EMAIL_HINT";
  static final String SIGNUP_PASSWORD_HINT = "SIGNUP_PASSWORD_HINT";
  static final String PHONE_HINT = "PHONE_HINT";
  static final String CONFIDENTIALITE_BEGIN = "CONFIDENTIALITE_BEGIN";
  static final String CONDITIONS_GENERALES = "CONDITIONS_GENERALES";
  static final String AND = "AND";
  static final String CONFIDENTIALITE = "CONFIDENTIALITE";

  static final String ERROR_FILL_ALL_GAPS = "ERROR_FILL_ALL_GAPS";
  static final String ERROR_ACCOUNT_ALREADY_EXISTS = "ERROR_ACCOUNT_ALREADY_EXISTS";



  // chaines lies a la page d'inscription
  static final String RECOVERY_PAGE_TITLE = "RECOVERY_PAGE_TITLE";
  static final String RECOVERY_DESCRIPTION_TEXT = "RECOVERY_DESCRIPTION_TEXT";
  static final String NEXT_BTN = "NEXT_BTN";

  static final String ERROR_UNKOWN_EMAIL = "UNKOWN_EMAIL";
  static final String ERROR_ENTER_EMAIL = "ENTER_EMAIL";



  // chaines lies a la page de confirmation
  static final String CONFIRMATION_PAGE_TITLE = "CONFIRMATION_PAGE_TITLE";
  static final String CONFIRMATION_DESCRIPTION_TEXT = "CONFIRMATION_DESCRIPTION_TEXT";
  static final String VALIDATE_BTN = "VALIDATE_BTN";

  static final String ERROR_WRONG_CODE = "ERROR_WRONG_CODE";
  static final String ERROR_INCOMPLETE_CODE = "ERROR_INCOMPLETE_CODE";



  // chaines lies a la page de redefinition du mot de passe
  static final String RESET_PASS_DESCRIPTION_TEXT = "RESET_PASS_DESCRIPTION_TEXT";
  static final String NEW_PASSWORD_HINT = "NEW_PASSWORD_HINT";
  static final String CONFIRM_PASSWORD_HINT = "CONFIRM_PASSWORD_HINT";
  static final String UPDATE_BTN = "UPDATE_BTN";
  static final String RESET_SUCCESS_TITLE = "RESET_SUCCESS_TITLE";
  static final String RESET_SUCCESS_MESSAGE = "RESET_SUCCESS_MESSAGE";
  static final String OK_BTN = "OK_BTN";

  static final String ERROR_PASS_AND_CONFIRM_NOT_MATCH = "ERROR_PASS_AND_CONFIRM_NOT_MATCH";
  static final String ERROR_OCCURED = "ERROR_OCCURED";



  // chaines lies a la page de d'accueil
  static final String ACCUEIL_TITLE = "ACCUEIL_TITLE";
  static final String SEARCH_TITLE = "SEARCH_TITLE";
  static final String CART_TITLE = "CART_TITLE";
  static final String COMMANDES_TITLE = "COMMANDES_TITLE";
  static final String PROFIL_TITLE = "PROFIL_TITLE";



  // chaines lies a la page de d'accueil
  static final String RESTAURANTS_NEARBY_TITLE = "RESTAURANTS_NEARBY_TITLE";
  static final String RESTAURANTS_NEARBY_NOT_FOUND = "RESTAURANTS_NEARBY_NOT_FOUND";


}