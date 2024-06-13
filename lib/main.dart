import 'dart:async';
import 'dart:io';

import 'package:beatapp/classes/app_user.dart';
import 'package:beatapp/constants/app_theme.dart';
import 'package:beatapp/ui/splash_screen.dart';
import 'package:beatapp/utility/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'localization/app_translations_delegate.dart';
import 'localization/application.dart';

Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('assets/cctnsup_gov_in.pem');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  return securityContext;
}

Future<http.Client> getSSLPinningClient() async {
  HttpClient client = HttpClient(context: await globalContext);
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => false;
  IOClient ioClient = IOClient(client);
  return ioClient;
}

late http.Client client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  client = await getSSLPinningClient();
  await AppUser.setBuildDetails();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  AppTranslationsDelegate? _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = const AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const SplashScreen(),
      localizationsDelegates: [
        _newLocaleDelegate!,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale("en", ""), Locale("hi", "")],
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  void initState() {
    Timer(
        const Duration(
          seconds: 6,
        ), () {
      if (Platform.isAndroid) {
        exit(0);
      } else {
        SystemNavigator.pop();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'lato'),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Warning..."),
          ),
          body: Container(
            alignment: Alignment.center,
            child: const Text(
              "Phone is in developer mode or rooted device\nApp will close in 5 sec",
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
