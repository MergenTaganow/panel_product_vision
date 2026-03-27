import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

abstract class EmployeeLocalDataSource {
  String? get username;
  String? get password;
  User? get user;
  bool? get rememberMe;
  String? get firebaseToken;
  String get appVersion;
  String? get rateSystem;
  String? get version;
  String? get tokenExpiryTime;
  // PrintSettingsModel get printSettings;

  set saveRememberMe(bool r);
  set saveRateSyst(String rSyst);
  // set setPrintSettings(PrintSettingsModel settings);

  // new added v2
  set setNavBarState(int index);
  int getNavbarState();
  setTokenExpiryTime(String time);
  // new added v2 end

  Future<void> saveUser({required User? u});
  set saveFirebaseToken(String? token);
  Future<void> signOut();
}

class EmployeeLocalDataSourceImpl extends EmployeeLocalDataSource {
  final SharedPreferences pref;
  EmployeeLocalDataSourceImpl({required this.pref});
  String? _username;
  String? _password;
  User? _user;
  bool? _rememberMe;
  String? _firebaseToken;
  String? _rateSyst;
  String? _version;

  @override
  String? get password => _password;

  @override
  String? get username => _username;

  @override
  User? get user {
    String usr = pref.getString('user') ?? '';

    if (usr.isEmpty) {
      return _user;
    }
    _user ??= User.fromJson(jsonDecode(usr));
    return _user;
  }

  @override
  Future<void> signOut() async {
    await pref.remove('account');
    await pref.remove('tokenExpiryTime');
    // await Hive.box('firebase').delete('firebaseOptions');
    _user = null;
  }

  @override
  bool? get rememberMe {
    final bool r = pref.getBool('rememberMe') ?? false;

    _rememberMe ??= r;

    return _rememberMe;
  }

  @override
  set saveRememberMe(bool r) {
    _rememberMe = r;
    pref.setBool('rememberMe', r);
  }

  @override
  String? get firebaseToken => _firebaseToken;

  @override
  set saveFirebaseToken(String? token) {
    _firebaseToken = token;
  }

  @override
  Future<void> saveUser({required User? u}) async {
    _user = u;

    await pref.setString('user', _user?.toJson() ?? '');
  }

  @override
  String get appVersion => _version ?? '1.2.4';

  @override
  String? get rateSystem {
    String rSyst = pref.getString('rateSystem') ?? '';

    if (rSyst.isEmpty) {
      return _rateSyst;
    }

    _rateSyst ??= rSyst;

    return _rateSyst;
  }

  @override
  set saveRateSyst(String rSyst) {
    pref.setString('rateSystem', rSyst);
    _rateSyst = rSyst;
    log('------   sending rate system : $rSyst   ------ ');
  }

  @override
  int getNavbarState() {
    var data = pref.getInt('navbarstate');
    return data ?? 0;
  }

  @override
  set setNavBarState(int index) {
    pref.setInt('navbarstate', index);
  }

  @override
  String? get version => _version;

  @override
  setTokenExpiryTime(String time) async {
    await pref.setString('tokenExpiryTime', time);
  }

  @override
  String? get tokenExpiryTime {
    return pref.getString('tokenExpiryTime');
  }

  // @override
  // set setPrintSettings(PrintSettingsModel settings) {
  //   pref.setString('printSet', jsonEncode(settings.toMap()));
  // }
  //
  // @override
  // PrintSettingsModel get printSettings {
  //   // pref.remove('printSet');
  //   String? result = pref.getString('printSet');
  //   if (result == null) {
  //     return PrintSettingsModel(
  //       printer: 'ata',
  //       labelSize: '45x15',
  //       labelType: 'qr',
  //       ribon: false,
  //     );
  //   } else {
  //     return PrintSettingsModel.fromMap(jsonDecode(result));
  //   }
  // }
}
