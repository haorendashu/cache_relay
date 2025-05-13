import 'package:cache_relay/const/base.dart';
import 'package:cache_relay/provider/traffic_counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:nostr_sdk/nip19/nip19.dart';
import 'package:nostr_sdk/utils/string_util.dart';
import 'package:provider/provider.dart';
import 'package:relay_sdk/network/connection.dart';

class ConnectionItemComponent extends StatefulWidget {
  Connection connection;

  ConnectionItemComponent(this.connection);

  @override
  State<StatefulWidget> createState() {
    return _ConnectionItemComponent();
  }
}

class _ConnectionItemComponent extends State<ConnectionItemComponent> {
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    String ip = widget.connection.ip;

    List<Widget> list = [];
    Widget ipWidget = Text(ip);
    list.add(ipWidget);

    if (StringUtil.isNotBlank(widget.connection.authPubkey)) {
      list.add(Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: EdgeInsets.only(
              top: 3,
              right: Base.BASE_PADDING_HALF,
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
          Text(Nip19.encodeSimplePubKey(widget.connection.authPubkey!)),
        ],
      ));
    }

    var main = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );

    return Container(
      decoration: BoxDecoration(
        color: themeData.dividerColor,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      padding: EdgeInsets.only(
        left: Base.BASE_PADDING,
        right: Base.BASE_PADDING,
        top: Base.BASE_PADDING_HALF,
        bottom: Base.BASE_PADDING_HALF,
      ),
      child: Row(
        children: [
          Expanded(child: main),
          Container(
            child: Selector<TrafficCounterProvider, String>(
              builder: (context, value, child) {
                return Text(value);
              },
              selector: (context, provider) {
                return provider
                    .getTraffic(widget.connection.id)
                    .toTrafficString();
              },
            ),
          ),
        ],
      ),
    );
  }
}
