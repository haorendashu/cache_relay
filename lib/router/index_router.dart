import 'package:bot_toast/bot_toast.dart';
import 'package:cache_relay/consts/base.dart';
import 'package:cache_relay/main.dart';
import 'package:cache_relay/provider/relay_provider.dart';
import 'package:cache_relay/provider/traffic_counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';

class IndexRouter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexRouter();
  }
}

class _IndexRouter extends State<IndexRouter> {
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var relayProvider = Provider.of<RelayProvider>(context);
    var padding = MediaQuery.of(context).padding;
    List<Widget> list = [];

    var largeFontSize = themeData.textTheme.bodyLarge!.fontSize;

    list.add(
      Positioned(
        left: Base.BASE_PADDING + Base.BASE_PADDING_HALF,
        top: Base.BASE_PADDING + padding.top,
        child: GestureDetector(
          onTap: () {},
          child: Icon(Icons.menu),
        ),
      ),
    );

    Widget button;
    if (relayProvider.isRunning()) {
      button = getStopWidget();

      List<Widget> subList = [];
      subList.add(Text(
        "Relay Address",
        style: TextStyle(
          fontSize: largeFontSize,
          fontWeight: FontWeight.bold,
        ),
      ));

      var relayAddress = "ws://${relayProvider.ip}:${relayProvider.port}";
      subList.add(Container(
        margin: EdgeInsets.only(top: Base.BASE_PADDING, bottom: 40),
        child: GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: relayAddress)).then((_) {
              BotToast.showText(text: "Copy Success");
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
      ));

      List<Widget> counterList = [];
      counterList.add(Expanded(
        child: buildCounterWidget("Traffic", buildTrafficWidget()),
      ));
      counterList.add(VerticalDivider());
      counterList.add(Expanded(
        child: buildCounterWidget(
          "Connections",
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
      child: Text("Start"),
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
      child: Text("Stop"),
    );
  }

  Widget buildCounterWidget(String title, Widget widget) {
    return Container(
      margin: EdgeInsets.only(
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
}
