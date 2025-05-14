import 'package:bot_toast/bot_toast.dart';
import 'package:cache_relay/provider/network_log_provider.dart';
import 'package:cache_relay/provider/relay_provider.dart';
import 'package:cache_relay/provider/traffic_counter_provider.dart';
import 'package:cache_relay/router/about_me/about_me_router.dart';
import 'package:cache_relay/router/connections/connections_router.dart';
import 'package:cache_relay/router/setting/setting_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nostr_sdk/utils/platform_util.dart';
import 'package:nostr_sdk/utils/sqlite_util.dart';
import 'package:nostr_sdk/utils/string_util.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'const/base.dart';
import 'const/colors.dart';
import 'const/router_path.dart';
import 'const/theme_style.dart';
import 'generated/l10n.dart';
import 'provider/data_util.dart';
import 'provider/setting_provider.dart';
import 'router/index/index_router.dart';
import 'util/colors_util.dart';

late SettingProvider settingProvider;

late NetworkLogProvider networkLogProvider;

late TrafficCounterProvider trafficCounterProvider;

late RelayProvider relayProvider;

late Map<String, WidgetBuilder> routes;

late RootIsolateToken rootIsolateToken;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  rootIsolateToken = RootIsolateToken.instance!;
  SqliteUtil.configSqliteFactory();

  if (!PlatformUtil.isWeb() && PlatformUtil.isPC()) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 800),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: Base.APP_NAME,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  var dataUtilTask = DataUtil.getInstance();
  var dataFutureResultList = await Future.wait([dataUtilTask]);

  var settingTask = SettingProvider.getInstance();
  var futureResultList = await Future.wait([settingTask]);
  settingProvider = futureResultList[0] as SettingProvider;

  networkLogProvider = NetworkLogProvider();
  trafficCounterProvider = TrafficCounterProvider();
  relayProvider = RelayProvider();

  trafficCounterProvider.startMoveTimer();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Color mainColor = _getMainColor();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: mainColor,
    // ));

    Locale? _locale;
    if (StringUtil.isNotBlank(settingProvider.i18n)) {
      for (var item in S.delegate.supportedLocales) {
        if (item.languageCode == settingProvider.i18n &&
            item.countryCode == settingProvider.i18nCC) {
          _locale = Locale(settingProvider.i18n!, settingProvider.i18nCC);
          break;
        }
      }
    }

    var lightTheme = getLightTheme();
    var darkTheme = getDarkTheme();
    ThemeData defaultTheme;
    ThemeData? defaultDarkTheme;
    if (settingProvider.themeStyle == ThemeStyle.LIGHT) {
      defaultTheme = lightTheme;
    } else if (settingProvider.themeStyle == ThemeStyle.DARK) {
      defaultTheme = darkTheme;
    } else {
      defaultTheme = lightTheme;
      defaultDarkTheme = darkTheme;
    }

    routes = {
      RouterPath.INDEX: (context) => IndexRouter(),
      RouterPath.CONNECTIONS: (context) => ConnectionsRouter(),
      RouterPath.SETTING: (context) => SettingRouter(indexReload: reload),
      RouterPath.ABOUT_ME: (context) => AboutMeRouter(),
    };

    return MultiProvider(
      providers: [
        ListenableProvider<SettingProvider>.value(
          value: settingProvider,
        ),
        ListenableProvider<NetworkLogProvider>.value(
          value: networkLogProvider,
        ),
        ListenableProvider<TrafficCounterProvider>.value(
          value: trafficCounterProvider,
        ),
        ListenableProvider<RelayProvider>.value(
          value: relayProvider,
        ),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        // showPerformanceOverlay: true,
        debugShowCheckedModeBanner: false,
        locale: _locale,
        title: Base.APP_NAME,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: defaultTheme,
        darkTheme: defaultDarkTheme,
        initialRoute: RouterPath.INDEX,
        routes: routes,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ThemeData getLightTheme() {
    Color color500 = _getMainColor();
    MaterialColor themeColor = ColorList.getThemeColor(color500.value);

    Color mainTextColor = Colors.black;
    Color hintColor = Colors.grey;
    var scaffoldBackgroundColor = Colors.grey[100];
    Color cardColor = Colors.white;

    double baseFontSize = settingProvider.fontSize;

    var textTheme = TextTheme(
      bodyLarge: TextStyle(fontSize: baseFontSize + 2, color: mainTextColor),
      bodyMedium: TextStyle(fontSize: baseFontSize, color: mainTextColor),
      bodySmall: TextStyle(fontSize: baseFontSize - 2, color: mainTextColor),
    );
    var titleTextStyle = TextStyle(
      color: mainTextColor,
    );

    return ThemeData(
      platform: TargetPlatform.iOS,
      primarySwatch: themeColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColor[500]!,
        brightness: Brightness.light,
      ),
      // scaffoldBackgroundColor: Base.SCAFFOLD_BACKGROUND_COLOR,
      // scaffoldBackgroundColor: Colors.grey[100],
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      primaryColor: themeColor[500],
      appBarTheme: AppBarTheme(
        backgroundColor: cardColor,
        titleTextStyle: titleTextStyle,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dividerColor: ColorsUtil.hexToColor("#DFE1EB"),
      cardColor: cardColor,
      // dividerColor: Colors.grey[200],
      // indicatorColor: ColorsUtil.hexToColor("#818181"),
      textTheme: textTheme,
      hintColor: hintColor,
      buttonTheme: ButtonThemeData(),
      shadowColor: Colors.black.withOpacity(0.2),
      tabBarTheme: TabBarTheme(
        indicatorColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[200],
      ),
    );
  }

  ThemeData getDarkTheme() {
    Color color500 = _getMainColor();
    MaterialColor themeColor = ColorList.getThemeColor(color500.value);

    Color? mainTextColor;
    // Color? topFontColor = Colors.white;
    Color? topFontColor = Colors.grey[200];
    Color hintColor = Colors.grey;
    var scaffoldBackgroundColor = Color.fromARGB(255, 40, 40, 40);
    Color cardColor = Colors.black;

    double baseFontSize = settingProvider.fontSize;

    var textTheme = TextTheme(
      bodyLarge: TextStyle(fontSize: baseFontSize + 2, color: mainTextColor),
      bodyMedium: TextStyle(fontSize: baseFontSize, color: mainTextColor),
      bodySmall: TextStyle(fontSize: baseFontSize - 2, color: mainTextColor),
    );
    var titleTextStyle = TextStyle(
      color: topFontColor,
      // color: Colors.black,
    );

    return ThemeData(
      platform: TargetPlatform.iOS,
      primarySwatch: themeColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColor[500]!,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      primaryColor: themeColor[500],
      appBarTheme: AppBarTheme(
        backgroundColor: cardColor,
        titleTextStyle: titleTextStyle,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dividerColor: Colors.grey[200],
      cardColor: cardColor,
      textTheme: textTheme,
      hintColor: hintColor,
      shadowColor: Colors.white.withOpacity(0.3),
      tabBarTheme: TabBarTheme(
        indicatorColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[200],
      ),
    );
  }
}

Color _getMainColor() {
  Color color500 = const Color(0xff519495);
  return color500;
}
