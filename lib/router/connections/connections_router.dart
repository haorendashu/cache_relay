import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../const/base.dart';
import '../../const/base_consts.dart';
import '../../generated/l10n.dart';
import '../../provider/relay_provider.dart';
import '../../util/router_util.dart';
import 'connection_item_component.dart';

class ConnectionsRouter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConnectionsRouter();
  }
}

class _ConnectionsRouter extends State<ConnectionsRouter> {
  @override
  Widget build(BuildContext context) {
    var s = S.of(context);
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
          s.Connections,
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
