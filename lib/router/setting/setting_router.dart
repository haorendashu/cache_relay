import 'package:bot_toast/bot_toast.dart';
import 'package:cache_relay/component/text_input/text_input_dialog.dart';
import 'package:cache_relay/const/base.dart';
import 'package:cache_relay/const/router_path.dart';
import 'package:cache_relay/provider/setting_provider.dart';
import 'package:cache_relay/util/router_util.dart';
import 'package:flutter/material.dart';
import 'package:nostr_sdk/utils/string_util.dart';
import 'package:provider/provider.dart';

import '../../component/enum_selector_component.dart';
import '../../const/base_consts.dart';
import '../../const/theme_style.dart';
import '../../generated/l10n.dart';
import '../../main.dart';
import '../../util/locale_util.dart';

class SettingRouter extends StatefulWidget {
  Function indexReload;

  SettingRouter({
    required this.indexReload,
  });

  @override
  State<StatefulWidget> createState() {
    return _SettingRouter();
  }
}

class _SettingRouter extends State<SettingRouter> {
  void resetTheme() {
    widget.indexReload();
  }

  late ThemeData themeData;

  late S s;

  @override
  Widget build(BuildContext context) {
    s = S.of(context);
    List<Widget> mainList = [];
    themeData = Theme.of(context);
    var _settingProvider = Provider.of<SettingProvider>(context);

    initOpenList(s);
    initI18nList(s);
    initCustomList(s);
    initThemeStyleList(s);

    {
      List<Widget> list = [];

      addItem(
        list,
        s.Language,
        showBorderBottom: true,
        onTap: pickI18N,
        value: getI18nList(settingProvider.i18n, settingProvider.i18nCC).name,
      );

      addItem(
        list,
        s.Theme_Style,
        onTap: pickThemeStyle,
        value: getThemeStyle(settingProvider.themeStyle).name,
      );

      wrapList(mainList, s.General, list);
    }

    {
      List<Widget> list = [];

      addItem(
        list,
        s.Relay_Host,
        showBorderBottom: true,
        onTap: inputRelayHost,
        value: settingProvider.relayHost,
      );
      addItem(
        list,
        s.Relay_Port,
        showBorderBottom: true,
        onTap: inputRelayPort,
        value: _settingProvider.relayPort?.toString(),
      );
      addItem(
        list,
        s.Event_Sign_Check,
        onTap: pickEventSignCheck,
        value: getOpenList(_settingProvider.eventSignCheck).name,
      );
      // addItem(list, s.Broadcase_user_s_events);

      wrapList(mainList, s.Relay_Config, list);
    }

    {
      List<Widget> list = [];

      addItem(list, s.About_me, onTap: () {
        RouterUtil.router(context, RouterPath.ABOUT_ME);
      });

      wrapList(mainList, s.About, list);
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            RouterUtil.back(context);
          },
          behavior: HitTestBehavior.translucent,
          child: Icon(Icons.chevron_left),
        ),
        title: Text(
          s.Setting,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: mainList,
        ),
      ),
    );
  }

  void wrapList(List<Widget> mainList, String title, List<Widget> list) {
    mainList.add(Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(
        top: Base.BASE_PADDING * 2,
        left: Base.BASE_PADDING,
        right: Base.BASE_PADDING,
        bottom: Base.BASE_PADDING,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: themeData.textTheme.bodyLarge!.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));

    mainList.add(Container(
      decoration: BoxDecoration(
        color: themeData.cardColor,
        borderRadius: BorderRadius.circular(
          Base.BASE_PADDING,
        ),
      ),
      margin: const EdgeInsets.only(
        left: Base.BASE_PADDING,
        right: Base.BASE_PADDING,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: list,
      ),
    ));
  }

  void addItem(List<Widget> list, String title,
      {String? value,
      Function? onTap,
      bool? showBorderTop,
      bool? showBorderBottom}) {
    var item = Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: Base.BASE_PADDING,
        right: Base.BASE_PADDING,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: showBorderTop == true
              ? BorderSide(
                  width: 1,
                  color: themeData.dividerColor,
                )
              : BorderSide.none,
          bottom: showBorderBottom == true
              ? BorderSide(
                  width: 1,
                  color: themeData.dividerColor,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(left: Base.BASE_PADDING_HALF),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
          StringUtil.isBlank(value)
              ? const Icon(Icons.chevron_right)
              : Text(
                  value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );

    list.add(GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: item,
    ));
  }

  List<EnumObj>? openList;

  void initOpenList(S s) {
    if (openList == null) {
      openList = [];
      openList!.add(EnumObj(OpenStatus.OPEN, s.open));
      openList!.add(EnumObj(OpenStatus.CLOSE, s.close));
    }
  }

  EnumObj getOpenList(int? value) {
    for (var o in openList!) {
      if (value == o.value) {
        return o;
      }
    }

    return openList![0];
  }

  EnumObj getOpenListDefault(int? value) {
    for (var o in openList!) {
      if (value == o.value) {
        return o;
      }
    }

    return openList![1];
  }

  List<EnumObj>? customList;

  void initCustomList(S s) {
    if (customList == null) {
      customList = [];
      customList!.add(EnumObj(CustomStatus.DEFAULT, s.Default));
      customList!.add(EnumObj(CustomStatus.CUSTOM, s.Custom));
    }
  }

  EnumObj getCustomList(int? value) {
    for (var o in customList!) {
      if (value == o.value) {
        return o;
      }
    }

    return customList![0];
  }

  List<EnumObj>? i18nList;

  void initI18nList(S s) {
    if (i18nList == null) {
      i18nList = [];
      i18nList!.add(EnumObj("", s.Auto));
      for (var item in S.delegate.supportedLocales) {
        var key = LocaleUtil.getLocaleKey(item);
        i18nList!.add(EnumObj(key, key));
      }
    }
  }

  EnumObj getI18nList(String? i18n, String? i18nCC) {
    var key = LocaleUtil.genLocaleKeyFromSring(i18n, i18nCC);
    for (var eo in i18nList!) {
      if (eo.value == key) {
        return eo;
      }
    }
    return EnumObj("", S.of(context).Auto);
  }

  Future pickI18N() async {
    EnumObj? resultEnumObj =
        await EnumSelectorComponent.show(context, i18nList!);
    if (resultEnumObj != null) {
      if (resultEnumObj.value == "") {
        settingProvider.setI18n(null, null);
      } else {
        for (var item in S.delegate.supportedLocales) {
          var key = LocaleUtil.getLocaleKey(item);
          if (resultEnumObj.value == key) {
            settingProvider.setI18n(item.languageCode, item.countryCode);
          }
        }
      }
      resetTheme();
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          // TODO others setting enumObjList
          i18nList = null;
        });
      });
    }
  }

  List<EnumObj>? themeStyleList;

  void initThemeStyleList(S s) {
    if (themeStyleList == null) {
      themeStyleList = [];
      themeStyleList?.add(EnumObj(ThemeStyle.AUTO, s.Follow_System));
      themeStyleList?.add(EnumObj(ThemeStyle.LIGHT, s.Light));
      themeStyleList?.add(EnumObj(ThemeStyle.DARK, s.Dark));
    }
  }

  Future<void> pickThemeStyle() async {
    EnumObj? resultEnumObj =
        await EnumSelectorComponent.show(context, themeStyleList!);
    if (resultEnumObj != null) {
      settingProvider.themeStyle = resultEnumObj.value;
      resetTheme();
    }
  }

  EnumObj getThemeStyle(int themeStyle) {
    for (var eo in themeStyleList!) {
      if (eo.value == themeStyle) {
        return eo;
      }
    }
    return themeStyleList![0];
  }

  inputRelayHost() async {
    var text = await TextInputDialog.show(
        context, "${s.Input_relay_host_title} (eg: localhost, 192.168.31.24)",
        value: settingProvider.relayHost);
    settingProvider.relayHost = text;
    BotToast.showText(text: s.Value_will_work_after_restar_relay);
  }

  inputRelayPort() async {
    var text = await TextInputDialog.show(
        context, "${s.Input_relay_port_title} (eg: 4869)",
        value: settingProvider.relayPort != null ? settingProvider.relayPort.toString() : "");
    if (StringUtil.isBlank(text)) {
      settingProvider.relayPort = null;
    } else {
      var port = int.tryParse(text!);
      settingProvider.relayPort = port;
    }

    BotToast.showText(text: s.Value_will_work_after_restar_relay);
  }

  pickEventSignCheck() async {
    EnumObj? resultEnumObj =
        await EnumSelectorComponent.show(context, openList!);
    if (resultEnumObj != null) {
      settingProvider.eventSignCheck = resultEnumObj.value;
      BotToast.showText(text: s.Value_will_work_after_restar_relay);
    }
  }
}
