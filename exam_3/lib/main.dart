import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:exam_3/views/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: ThemeData(fontFamily: 'WorkSans'),

        darkTheme: darkTheme,

        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
        // themeMode: AdaptiveTheme.of(context).mode,
      ),
    );
  }
}
