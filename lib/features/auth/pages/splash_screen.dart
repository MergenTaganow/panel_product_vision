import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panel_image_uploader/config/colors.dart';
import 'package:panel_image_uploader/config/go.dart';
import 'package:panel_image_uploader/config/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/aut_bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigate();
    super.initState();
  }

  void navigate() async {
    await Future.delayed(const Duration(seconds: 5));
    if (await checkIP() == false) {
      Go.too(Routes.ipChanging);
    }
  }

  Future<bool> checkIP() async {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    final SharedPreferences prefes = await prefs;
    if (prefes.containsKey('ip_was_set')) {
      return (prefes.getBool('ip_was_set')) ?? false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Go.too(Routes.itemsPage);
        }
        if (state is AuthInitial) {
          Go.too(Routes.login);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF7EBDE).withOpacity(0.6),
                const Color(0xFFF59D7D).withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/app_full_logo.png'),
              Text(
                "Panel Product Vision",
                style: TextStyle(color: Col.primary, fontSize: 25, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
