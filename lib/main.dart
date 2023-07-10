import 'package:flutter/material.dart';
import 'package:flutter_laundry_app/config/app_colors.dart';
import 'package:flutter_laundry_app/config/app_session.dart';
import 'package:flutter_laundry_app/pages/auth/login_page.dart';
import 'package:flutter_laundry_app/pages/dashboard_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: Colors.greenAccent[400]!,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.primary),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            textStyle: MaterialStatePropertyAll(
              TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      // home: const RegisterPage(),
      home: FutureBuilder(
        future: AppSession.getUser(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            // print('user: null');
            return const LoginPage();
          }
          // print(snapshot.data!.toJson());
          return const DashboardPage();
        },
      ),
    );
  }
}
