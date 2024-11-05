import 'package:cache_relay/main.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:nostr_sdk/relay/relay_info.dart';
import 'package:relay_sdk/network/connection.dart';
import 'package:relay_sdk/relay_manager.dart';

class RelayProvider extends ChangeNotifier {
  String ip = "127.0.0.1";

  int port = 4869;

  RelayInfo relayInfo = RelayInfo(
      "Local Relay",
      "This is a cache relay. It will cache some event.",
      "29320975df855fe34a7b45ada2421e2c741c37c0136901fe477133a91eb18b07",
      "29320975df855fe34a7b45ada2421e2c741c37c0136901fe477133a91eb18b07",
      ["1", "11", "12", "16", "33", "42", "45", "50", "95"],
      "Cache Relay",
      "0.1.0");

  RelayManager? _relayManager;

  bool isRunning() {
    if (_relayManager != null) {
      return true;
    }

    return false;
  }

  Future<void> start() async {
    final info = NetworkInfo();
    String? localIp = await info.getWifiIP();
    if (localIp != null) {
      ip = localIp;
    }

    var rm = _getRelayManager();
    rm.start(relayInfo, port);

    notifyListeners();
  }

  void stop() {
    if (_relayManager != null) {
      _relayManager!.stop();
    }

    _relayManager = null;

    notifyListeners();
  }

  RelayManager _getRelayManager() {
    if (_relayManager == null) {
      _relayManager = RelayManager(rootIsolateToken);
      _relayManager!.openFilterCheck = false;
      _relayManager!.trafficCounter = trafficCounterProvider;
      _relayManager!.networkLogsManager = networkLogProvider;
      _relayManager!.rootIsolateToken = rootIsolateToken;
      _relayManager!.connectionListener = connectionListener;
    }

    return _relayManager!;
  }

  int connectionNum() {
    if (_relayManager != null) {
      return _relayManager!.getConnections().length;
    }

    return 0;
  }

  List<Connection> getConnections() {
    if (_relayManager != null) {
      return _relayManager!.getConnections();
    }

    return [];
  }

  void connectionListener() {
    notifyListeners();
  }
}
