import 'package:bot_toast/bot_toast.dart';
import 'package:cache_relay/const/base.dart';
import 'package:cache_relay/const/router_path.dart';
import 'package:cache_relay/main.dart';
import 'package:cache_relay/provider/relay_provider.dart';
import 'package:cache_relay/provider/traffic_counter_provider.dart';
import 'package:cache_relay/util/router_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';

class IndexRouter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexRouter();
  }
}

class _IndexRouter extends State<IndexRouter> {
  int addressType = 0;

  void changeAddressType() {
    addressType++;
    addressType %= 3;
    setState(() {});
  }

  late S s;

  @override
  Widget build(BuildContext context) {
    s = S.of(context);
    var themeData = Theme.of(context);
    var relayProvider = Provider.of<RelayProvider>(context);
    var padding = MediaQuery.of(context).padding;
    List<Widget> list = [];

    var largeFontSize = themeData.textTheme.bodyLarge!.fontSize;

    list.add(
      Positioned(
        left: Base.BASE_PADDING + Base.BASE_PADDING_HALF,
        top: 20 + padding.top,
        child: GestureDetector(
          onTap: () {
            RouterUtil.router(context, RouterPath.SETTING);
          },
          child: Icon(Icons.menu),
        ),
      ),
    );

    Widget button;
    if (relayProvider.isRunning()) {
      button = getStopWidget();

      List<Widget> subList = [];
      subList.add(Text(
        s.Relay_Address,
        style: TextStyle(
          fontSize: largeFontSize,
          fontWeight: FontWeight.bold,
        ),
      ));

      var relayAddress = "ws://${relayProvider.ip}:${relayProvider.port}";
      if (addressType == 1) {
        relayAddress = "ws://127.0.0.1:${relayProvider.port}";
      } else {
        if (addressType == 2) {
          relayAddress = "ws://localhost:${relayProvider.port}";
        }
      }

      subList.add(Container(
        margin: EdgeInsets.only(top: Base.BASE_PADDING, bottom: 40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: Base.BASE_PADDING_HALF),
              child: GestureDetector(
                onTap: changeAddressType,
                child: Icon(Icons.autorenew),
              ),
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: relayAddress)).then((_) {
                  BotToast.showText(text: s.Copy_Success);
                });
              },
              child: Card(
                child: Container(
                  padding: EdgeInsets.only(
                    left: Base.BASE_PADDING * 2,
                    right: Base.BASE_PADDING * 2,
                    top: Base.BASE_PADDING_HALF,
                    bottom: Base.BASE_PADDING_HALF,
                  ),
                  child: Text(relayAddress),
                ),
              ),
            ),
            Container(
              width: 20,
            )
          ],
        ),
      ));

      List<Widget> counterList = [];
      counterList.add(Expanded(
        child: buildCounterWidget(s.Traffic, buildTrafficWidget()),
      ));
      counterList.add(VerticalDivider());
      counterList.add(Expanded(
        child: buildCounterWidget(
          s.Connections,
          Text(
            relayProvider.connectionNum().toString(),
          ),
        ),
      ));
      subList.add(IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: counterList,
        ),
      ));

      list.add(Container(
        margin: EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: subList,
        ),
      ));
    } else {
      list.add(
        Positioned(
          left: 0,
          right: 0,
          child: Container(
            height: 300,
            margin: EdgeInsets.only(bottom: 100),
            child: Swiper.children(
              pagination: SwiperPagination(),
              children: [
                buildDesCard(
                  s.App_des_title_1,
                  s.App_des_info_1,
                  themeData.cardColor,
                ),
                buildDesCard(
                  s.App_des_title_2,
                  s.App_des_info_2,
                  themeData.cardColor,
                ),
                buildDesCard(
                  s.App_des_title_3,
                  s.App_des_info_3,
                  themeData.cardColor,
                ),
                buildDesCard(
                  s.App_des_title_4,
                  s.App_des_info_4,
                  themeData.cardColor,
                ),
              ],
            ),
          ),
        ),
      );

      button = getStartWidget();
    }

    list.add(
      Positioned(
        bottom: 50 + padding.bottom,
        left: 50,
        right: 50,
        child: button,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: list,
        ),
      ),
    );
  }

  Widget getStartWidget() {
    return FilledButton(
      onPressed: () {
        relayProvider.start();
      },
      child: Text(s.Start),
    );
  }

  Widget getStopWidget() {
    return FilledButton(
      onPressed: () {
        relayProvider.stop();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.red),
      ),
      child: Text(s.Stop),
    );
  }

  Widget buildCounterWidget(String title, Widget widget) {
    return GestureDetector(
      onTap: () {
        RouterUtil.router(context, RouterPath.CONNECTIONS);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: const EdgeInsets.only(
          top: Base.BASE_PADDING_HALF,
          bottom: Base.BASE_PADDING_HALF,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: Base.BASE_PADDING_HALF),
              child: Text(title),
            ),
            widget,
          ],
        ),
      ),
    );
  }

  Widget buildTrafficWidget() {
    return Selector<TrafficCounterProvider, String>(
      builder: (context, value, child) {
        return Text(value);
      },
      selector: (context, provider) {
        return provider.totalTraffic.toTrafficString();
      },
    );
  }

  Widget buildDesCard(String title, String s, Color color) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: 300,
        width: 300,
        padding: const EdgeInsets.all(Base.BASE_PADDING_HALF),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(Base.BASE_PADDING),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              // textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: Base.BASE_PADDING, bottom: Base.BASE_PADDING),
              child: Text(
                s,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
