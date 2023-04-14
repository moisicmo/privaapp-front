import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData.light().copyWith(
      textTheme: ThemeData.light(useMaterial3: true)
          .textTheme
          .copyWith(
            bodyMedium: const TextStyle(color: Colors.black),
            bodyLarge: const TextStyle(color: Colors.black),
          )
          .apply(
            fontFamily: 'Poppins',
          ),
      inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
            fillColor: const Color(0xffEBEDEE),
            isDense: true,
            filled: true,
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Color(0xff419388))),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(color: Colors.red, width: 1)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                )),
            iconColor: Colors.black,
            errorStyle: const TextStyle().apply(color: Colors.red, fontFamily: 'Poppins'),
          ),
      drawerTheme: const DrawerThemeData().copyWith(
        backgroundColor: const Color(0xfff2f2f2),
      ),
      buttonTheme: ButtonThemeData(
          padding: const EdgeInsets.all(0),
          splashColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textTheme: ButtonTextTheme.accent),
      primaryTextTheme: ThemeData.dark(useMaterial3: true).textTheme.apply(fontFamily: 'Poppins'),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(primary: const Color(0xff21232A), secondary: const Color(0xff21232A)),
      primaryColor: const Color(0xffFE6311),
      cardColor: const Color(0xfff2f2f2),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      dialogBackgroundColor: const Color(0xfff2f2f2),
      scaffoldBackgroundColor: const Color(0xfff2f2f2),
      primaryColorDark: const Color(0xff21232A),
      listTileTheme: const ListTileThemeData().copyWith(iconColor: Colors.black),
      primaryIconTheme: const IconThemeData().copyWith(color: Colors.black),
      iconTheme: const IconThemeData(color: Colors.black),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0).copyWith(
          titleTextStyle: const TextStyle(color: Colors.black), iconTheme: const IconThemeData(color: Colors.black)));
}
