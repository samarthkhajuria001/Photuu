import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:photuu/providers/user_providers.dart';
import 'package:photuu/screens/edit_profile_screen.dart';
import 'package:photuu/screens/home_screen.dart';
import 'package:photuu/screens/login_screen.dart';
import 'package:photuu/screens/searched_user_screen.dart';
import 'package:photuu/screens/signup_screen.dart';
import 'package:photuu/utils/colors.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      )
    ],
    child: MaterialApp(
      title: 'Photuu App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      routes: {
        loginScreen: (context) => const LogInScreen(),
        signUpScreen: (context) => const SignUpScreen(),
        homePage: (context) => const HomeScreen(),
        editAccountDetails: (context) => EditProfile(),
        searchedUserScreen: (context) => SearchedUser(),
      },
      home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if (snapshot.hasData) {
                  return HomeScreen();
                } else if (snapshot.data == null) {
                  return LogInScreen();
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else {
                  return const Center(child: Text('Some Error Occured'));
                }
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                ));
              default:
                return const LogInScreen();
            }
          }),
    ),
  ));
}

const String loginScreen = '/login';
const String signUpScreen = '/signup';
const String homePage = '/homepage';
const String editAccountDetails = '/editAccount';
const String searchedUserScreen = '/searchedUser';
