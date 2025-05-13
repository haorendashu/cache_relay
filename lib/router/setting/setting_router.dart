import 'package:cache_relay/consts/base.dart';
import 'package:cache_relay/consts/router_path.dart';
import 'package:cache_relay/util/router_util.dart';
import 'package:flutter/material.dart';
import 'package:nostr_sdk/utils/string_util.dart';

class SettingRouter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingRouter();
  }
}

class _SettingRouter extends State<SettingRouter> {
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    List<Widget> mainList = [];
    themeData = Theme.of(context);

    {
      List<Widget> list = [];

      addItem(list, "Language");

      wrapList(mainList, "General", list);
    }

    {
      List<Widget> list = [];

      addItem(list, "Relay Host", showBorderBottom: true);
      addItem(list, "Relay Port", showBorderBottom: true);
      addItem(list, "Broadcase user's events");

      wrapList(mainList, "Relay Config", list);
    }

    {
      List<Widget> list = [];

      addItem(list, "About me", onTap: () {
        RouterUtil.router(context, RouterPath.ABOUT_ME);
      });

      wrapList(mainList, "About", list);
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
          "Setting",
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
}
