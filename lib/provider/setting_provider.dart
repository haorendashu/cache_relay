import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:nostr_sdk/utils/string_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/base.dart';
import '../const/base_consts.dart';
import '../const/theme_style.dart';
import 'data_util.dart';

class SettingProvider extends ChangeNotifier {
  static SettingProvider? _settingProvider;

  SharedPreferences? _sharedPreferences;

  SettingData? _settingData;

  static Future<SettingProvider> getInstance() async {
    if (_settingProvider == null) {
      _settingProvider = SettingProvider();
      _settingProvider!._sharedPreferences = await DataUtil.getInstance();
      await _settingProvider!._init();
    }
    return _settingProvider!;
  }

  Future<void> _init() async {
    String? settingStr = _sharedPreferences!.getString(DataKey.SETTING);
    if (StringUtil.isNotBlank(settingStr)) {
      var jsonMap = json.decode(settingStr!);
      if (jsonMap != null) {
        var setting = SettingData.fromJson(jsonMap);
        _settingData = setting;

        return;
      }
    }

    _settingData = SettingData();
  }

  Future<void> reload() async {
    await _init();
    notifyListeners();
  }

  SettingData get settingData => _settingData!;

  /// open lock
  int get lockOpen => _settingData!.lockOpen;

  /// i18n
  String? get i18n => _settingData!.i18n;

  String? get i18nCC => _settingData!.i18nCC;

  /// theme style
  int get themeStyle => _settingData!.themeStyle;

  Map<String, int> _translateSourceArgsMap = {};

  bool translateSourceArgsCheck(String str) {
    return _translateSourceArgsMap[str] != null;
  }

  double get fontSize => _settingData!.fontSize ?? Base.BASE_FONT_SIZE;

  int? get relayMode => _settingData!.relayMode;

  int? get eventSignCheck => _settingData!.eventSignCheck;

  String? get relayHost => _settingData!.relayHost;

  int? get relayPort => _settingData!.relayPort;

  set settingData(SettingData o) {
    _settingData = o;
    saveAndNotifyListeners();
  }

  /// open lock
  set lockOpen(int o) {
    _settingData!.lockOpen = o;
    saveAndNotifyListeners();
  }

  /// i18n
  set i18n(String? o) {
    _settingData!.i18n = o;
    saveAndNotifyListeners();
  }

  void setI18n(String? i18n, String? i18nCC) {
    _settingData!.i18n = i18n;
    _settingData!.i18nCC = i18nCC;
    saveAndNotifyListeners();
  }

  /// theme style
  set themeStyle(int o) {
    _settingData!.themeStyle = o;
    saveAndNotifyListeners();
  }

  set fontSize(double o) {
    _settingData!.fontSize = o;
    saveAndNotifyListeners();
  }

  set relayMode(int? o) {
    _settingData!.relayMode = o;
    saveAndNotifyListeners();
  }

  set eventSignCheck(int? o) {
    _settingData!.eventSignCheck = o;
    saveAndNotifyListeners();
  }

  set relayHost(String? o) {
    _settingData!.relayHost = o;
    saveAndNotifyListeners();
  }

  set relayPort(int? o) {
    _settingData!.relayPort = o;
    saveAndNotifyListeners();
  }

  Future<void> saveAndNotifyListeners({bool updateUI = true}) async {
    _settingData!.updatedTime = DateTime.now().millisecondsSinceEpoch;
    var m = _settingData!.toJson();
    var jsonStr = json.encode(m);
    // print(jsonStr);
    await _sharedPreferences!.setString(DataKey.SETTING, jsonStr);

    if (updateUI) {
      notifyListeners();
    }
  }
}

class SettingData {
  /// open lock
  late int lockOpen;

  /// i18n
  String? i18n;

  String? i18nCC;

  /// theme style
  late int themeStyle;

  double? fontSize;

  int? relayMode;

  int? eventSignCheck;

  String? relayHost;

  int? relayPort;

  /// updated time
  late int updatedTime;

  SettingData({
    this.lockOpen = OpenStatus.CLOSE,
    this.i18n,
    this.i18nCC,
    this.themeStyle = ThemeStyle.AUTO,
    this.fontSize,
    this.relayMode,
    this.eventSignCheck,
    this.relayHost,
    this.relayPort,
    this.updatedTime = 0,
  });

  SettingData.fromJson(Map<String, dynamic> json) {
    if (json['lockOpen'] != null) {
      lockOpen = json['lockOpen'];
    } else {
      lockOpen = OpenStatus.CLOSE;
    }
    i18n = json['i18n'];
    i18nCC = json['i18nCC'];
    if (json['themeStyle'] != null) {
      themeStyle = json['themeStyle'];
    } else {
      themeStyle = ThemeStyle.AUTO;
    }
    fontSize = json['fontSize'];
    relayMode = json['relayMode'];
    eventSignCheck = json['eventSignCheck'];
    relayHost = json['relayHost'];
    relayPort = json['relayPort'];
    if (json['updatedTime'] != null) {
      updatedTime = json['updatedTime'];
    } else {
      updatedTime = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lockOpen'] = this.lockOpen;
    data['i18n'] = this.i18n;
    data['i18nCC'] = this.i18nCC;
    data['themeStyle'] = this.themeStyle;
    data['fontSize'] = this.fontSize;
    data['relayMode'] = this.relayMode;
    data['eventSignCheck'] = this.eventSignCheck;
    data['relayHost'] = this.relayHost;
    data['relayPort'] = this.relayPort;
    data['updatedTime'] = this.updatedTime;
    return data;
  }
}
