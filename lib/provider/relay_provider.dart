import 'package:bot_toast/bot_toast.dart';
import 'package:cache_relay/const/base.dart';
import 'package:cache_relay/main.dart';
import 'package:cache_relay/util/ip_util.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:nostr_sdk/relay/relay_info.dart';
import 'package:nostr_sdk/utils/string_util.dart';
import 'package:relay_sdk/network/connection.dart';
import 'package:relay_sdk/relay_manager.dart';

class RelayProvider extends ChangeNotifier {
  String ip = "127.0.0.1";

  int port = Base.DEFAULT_PORT;

  RelayInfo relayInfo = RelayInfo(
      Base.APP_NAME,
      "This is a cache relay. It will cache some event.",
      "29320975df855fe34a7b45ada2421e2c741c37c0136901fe477133a91eb18b07",
      "29320975df855fe34a7b45ada2421e2c741c37c0136901fe477133a91eb18b07",
      ["1", "11", "12", "16", "33", "42", "45", "50", "95"],
      Base.APP_NAME,
      Base.VERSION_NAME);

  RelayManager? _relayManager;

  bool isRunning() {
    if (_relayManager != null) {
      return true;
    }

    return false;
  }

  Future<void> start() async {
    // final info = NetworkInfo();
    // String? localIp = await info.getWifiIP();
    String? localIp = await IpUtil.getIp();
    if (localIp != null) {
      ip = localIp;
    }

    try {
      var rm = _getRelayManager();
      port = settingProvider.relayPort ?? Base.DEFAULT_PORT;
      if (StringUtil.isNotBlank(settingProvider.relayHost)) {
        ip = settingProvider.relayHost!;
      }

      await rm.start(relayInfo, port);
    } catch (e) {
      print(e);
      BotToast.showText(text: "Start server fail.");
      if (_relayManager != null) {
        try {
          _relayManager!.stop();
        } catch (e) {}
      }
      _relayManager = null;
    }

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
      _relayManager = RelayManager(rootIsolateToken, Base.APP_NAME);
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
