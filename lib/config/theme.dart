// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData off(context) {
    var theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Col.primary,
      useMaterial3: false,
      bottomAppBarTheme: BottomAppBarTheme(color: Col.white),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Col.gray50),
      canvasColor: Colors.transparent,
      dividerColor: Colors.transparent,
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(Colors.blue),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.compact,
        fillColor: PrimeColour(100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      appBarTheme: theme.appBarTheme.copyWith(
        titleTextStyle: TextStyle(
          color: Col.black,
          fontSize: 16 /*  * serv.ratio */,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Col.black),
        backgroundColor: Col.white,
        centerTitle: false,
        elevation: 0,
      ),
      buttonTheme: ButtonThemeData(),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Col.white,
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: TextStyle(color: Col.black, fontSize: 0, fontWeight: FontWeight.w400),
        selectedLabelStyle: TextStyle(color: Col.white, fontSize: 0, fontWeight: FontWeight.w600),
      ),
      textTheme: theme.textTheme
          .copyWith(
            /* H1 */
            displayLarge: theme.textTheme.displayLarge!.copyWith(
              color: Col.black,
              fontSize: 32 /* * serv.ratio */,
              fontWeight: FontWeight.w700,
            ),
            /* H2 */
            displayMedium: theme.textTheme.displayMedium!.copyWith(
              color: Col.black,
              fontSize: 28 /* * serv.ratio */,
              fontWeight: FontWeight.w600,
            ),
            /* H3 */
            displaySmall: theme.textTheme.displaySmall!.copyWith(
              color: Col.black,
              fontSize: 24 /* * serv.ratio */,
              fontWeight: FontWeight.w600,
            ),
            titleLarge: theme.textTheme.titleLarge!.copyWith(
              fontSize: 18 /* * serv.ratio */,
              color: Col.black,
              fontWeight: FontWeight.w600,
            ),
            /* B1 */
            bodyLarge: theme.textTheme.bodyLarge!.copyWith(
              fontSize: 16 /* * serv.ratio */,
              color: Col.black,
              fontWeight: FontWeight.w400,
            ),
            /* B2 */
            bodyMedium: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 14 /* * serv.ratio */,
              color: Col.black,
              fontWeight: FontWeight.w400,
            ),

            /* B3  */
            headlineSmall: theme.textTheme.headlineSmall!.copyWith(
              color: Col.black,
              fontSize: 13 /* * serv.ratio */,
              fontWeight: FontWeight.w400,
            ),
            /* T1 */
            labelSmall: theme.textTheme.labelSmall!.copyWith(
              color: Col.black,
              fontSize: 12 /* * serv.ratio */,
              fontWeight: FontWeight.w400,
            ),
            /* T2*/
            bodySmall: theme.textTheme.bodySmall!.copyWith(
              color: Col.black,
              fontSize: 11 /* * serv.ratio */,
              fontWeight: FontWeight.w500,
            ),
          )
          .apply(fontFamily: 'Poppins'),
      tabBarTheme: TabBarTheme(
        labelColor: Col.primary,
        unselectedLabelColor: Col.black,
        indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Col.primary, width: 2)),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: theme.textTheme.headlineMedium!.copyWith(
          color: Col.primary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
        unselectedLabelStyle: theme.textTheme.headlineMedium!.copyWith(
          color: Col.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Col.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),
      scaffoldBackgroundColor: Colors.white,
      pageTransitionsTheme: PageTransitionsTheme(builders: getTranzition),
    );
  }

  static Map<TargetPlatform, PageTransitionsBuilder> get getTranzition {
    return {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    };
  }
}

class PrimeColour extends MaterialStateColor {
  PrimeColour(super.defaultValue);
  @override
  Color resolve(Set<MaterialState> states) {
    return states.contains(MaterialState.selected) ? Col.primary : Col.white;
  }
}

class PrimeColourBlack extends MaterialStateColor {
  PrimeColourBlack(super.defaultValue);
  @override
  Color resolve(Set<MaterialState> states) {
    return Col.black;
  }
}

class Styles {
  final smallItemShadow = BoxShadow(
    blurRadius: 15,
    spreadRadius: 0,
    color: Color(0x57595F1A).withOpacity(15),
    offset: Offset(0, 10),
  );
  final sideCategorySh = BoxShadow(
    blurRadius: 4,
    spreadRadius: 1,
    color: Color.fromARGB(86, 0, 0, 0).withOpacity(4),
    offset: Offset(0, 1),
  );

  static final cartShadow = BoxShadow(
    blurRadius: 16,
    spreadRadius: 0,
    color: Col.black.withOpacity(.04),
    offset: Offset(0, 10),
  );
  static final searchSh = BoxShadow(
    blurRadius: 10,
    color: Colors.black.withOpacity(.05),
    offset: const Offset(0, 0),
    spreadRadius: 0,
  );
}
