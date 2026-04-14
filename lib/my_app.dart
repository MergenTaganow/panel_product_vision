import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'features/global/data/dynamic_localization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String version = '1.0.0';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static Locale? appLocale = const Locale('tr');

  @override
  void initState() {
    DynamicLocalization.init(appLocale);
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.off(context),
      navigatorKey: Routes.mainNavKey,
      initialRoute: Routes.splashScreen,
      onGenerateRoute: Routes.onGenerateRoute,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: appLocale,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: child!,
        );
      },
    );
  }

  setLocale(Locale locale) async {
    setState(() {
      appLocale = locale;
    });
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences prefes = await prefs;
    prefes.setString('lang', locale.languageCode);
    DynamicLocalization.init(locale);
  }

  getLang() async {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences prefes = await prefs;
    if (prefes.containsKey('lang')) {
      var ll = prefes.getString('lang');
      if (ll != null) {
        setState(() {
          appLocale = Locale(ll);
        });
      }
    }
  }
}
