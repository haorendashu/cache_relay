// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Confirm`
  String get Confirm {
    return Intl.message('Confirm', name: 'Confirm', desc: '', args: []);
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message('Cancel', name: 'Cancel', desc: '', args: []);
  }

  /// `Open`
  String get open {
    return Intl.message('Open', name: 'open', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Show`
  String get Show {
    return Intl.message('Show', name: 'Show', desc: '', args: []);
  }

  /// `Hide`
  String get Hide {
    return Intl.message('Hide', name: 'Hide', desc: '', args: []);
  }

  /// `Auto`
  String get Auto {
    return Intl.message('Auto', name: 'Auto', desc: '', args: []);
  }

  /// `Custom`
  String get Custom {
    return Intl.message('Custom', name: 'Custom', desc: '', args: []);
  }

  /// `Default`
  String get Default {
    return Intl.message('Default', name: 'Default', desc: '', args: []);
  }

  /// `Relay Address`
  String get Relay_Address {
    return Intl.message(
      'Relay Address',
      name: 'Relay_Address',
      desc: '',
      args: [],
    );
  }

  /// `Copy Success`
  String get Copy_Success {
    return Intl.message(
      'Copy Success',
      name: 'Copy_Success',
      desc: '',
      args: [],
    );
  }

  /// `Traffic`
  String get Traffic {
    return Intl.message('Traffic', name: 'Traffic', desc: '', args: []);
  }

  /// `Connections`
  String get Connections {
    return Intl.message('Connections', name: 'Connections', desc: '', args: []);
  }

  /// `Improve data access speed`
  String get App_des_title_1 {
    return Intl.message(
      'Improve data access speed',
      name: 'App_des_title_1',
      desc: '',
      args: [],
    );
  }

  /// `Locally cache high-frequency data, millisecond response, say goodbye to the loading wait of public relays, and make real-time social interaction as smooth as flowing water.`
  String get App_des_info_1 {
    return Intl.message(
      'Locally cache high-frequency data, millisecond response, say goodbye to the loading wait of public relays, and make real-time social interaction as smooth as flowing water.',
      name: 'App_des_info_1',
      desc: '',
      args: [],
    );
  }

  /// `Ensure data reliability`
  String get App_des_title_2 {
    return Intl.message(
      'Ensure data reliability',
      name: 'App_des_title_2',
      desc: '',
      args: [],
    );
  }

  /// `Critical information is stored locally and persistently. Even if the global relay is down, your content is still safe and can be retrieved at any time.`
  String get App_des_info_2 {
    return Intl.message(
      'Critical information is stored locally and persistently. Even if the global relay is down, your content is still safe and can be retrieved at any time.',
      name: 'App_des_info_2',
      desc: '',
      args: [],
    );
  }

  /// `Support offline access`
  String get App_des_title_3 {
    return Intl.message(
      'Support offline access',
      name: 'App_des_title_3',
      desc: '',
      args: [],
    );
  }

  /// `You can browse cached content even without network, and check historical messages and personal dynamics at any time. After the network is restored, it will automatically update online.`
  String get App_des_info_3 {
    return Intl.message(
      'You can browse cached content even without network, and check historical messages and personal dynamics at any time. After the network is restored, it will automatically update online.',
      name: 'App_des_info_3',
      desc: '',
      args: [],
    );
  }

  /// `Optimize network load`
  String get App_des_title_4 {
    return Intl.message(
      'Optimize network load',
      name: 'App_des_title_4',
      desc: '',
      args: [],
    );
  }

  /// `Locally handle a large number of repeated requests, greatly reduce the pressure of public relay traffic, and speed up and reduce the burden on Nostr network.`
  String get App_des_info_4 {
    return Intl.message(
      'Locally handle a large number of repeated requests, greatly reduce the pressure of public relay traffic, and speed up and reduce the burden on Nostr network.',
      name: 'App_des_info_4',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get Start {
    return Intl.message('Start', name: 'Start', desc: '', args: []);
  }

  /// `Stop`
  String get Stop {
    return Intl.message('Stop', name: 'Stop', desc: '', args: []);
  }

  /// `Language`
  String get Language {
    return Intl.message('Language', name: 'Language', desc: '', args: []);
  }

  /// `General`
  String get General {
    return Intl.message('General', name: 'General', desc: '', args: []);
  }

  /// `Relay Host`
  String get Relay_Host {
    return Intl.message('Relay Host', name: 'Relay_Host', desc: '', args: []);
  }

  /// `Relay Port`
  String get Relay_Port {
    return Intl.message('Relay Port', name: 'Relay_Port', desc: '', args: []);
  }

  /// `Broadcase user's events`
  String get Broadcase_user_s_events {
    return Intl.message(
      'Broadcase user\'s events',
      name: 'Broadcase_user_s_events',
      desc: '',
      args: [],
    );
  }

  /// `Relay Config`
  String get Relay_Config {
    return Intl.message(
      'Relay Config',
      name: 'Relay_Config',
      desc: '',
      args: [],
    );
  }

  /// `About me`
  String get About_me {
    return Intl.message('About me', name: 'About_me', desc: '', args: []);
  }

  /// `About`
  String get About {
    return Intl.message('About', name: 'About', desc: '', args: []);
  }

  /// `Setting`
  String get Setting {
    return Intl.message('Setting', name: 'Setting', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bg'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'da'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'el'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'et'),
      Locale.fromSubtags(languageCode: 'fi'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hu'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ro'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'sl'),
      Locale.fromSubtags(languageCode: 'sv'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
