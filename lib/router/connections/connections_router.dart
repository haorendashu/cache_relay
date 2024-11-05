import 'package:cache_relay/consts/base.dart';
import 'package:cache_relay/provider/relay_provider.dart';
import 'package:cache_relay/router/connections/connection_item_component.dart';
import 'package:cache_relay/util/router_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectionsRouter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConnectionsRouter();
  }
}

class _ConnectionsRouter extends State<ConnectionsRouter> {
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var relayProvider = Provider.of<RelayProvider>(context);
    var connections = relayProvider.getConnections();

    List<Widget> list = [];
    for (var connection in connections) {
      list.add(ConnectionItemComponent(connection));
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            RouterUtil.back(context);
          },
          behavior: HitTestBehavior.translucent,
          child: const Icon(Icons.chevron_left),
        ),
        title: Text(
          "Connections",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: themeData.textTheme.bodyLarge!.fontSize,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(Base.BASE_PADDING),
        children: list,
      ),
    );
  }
}
