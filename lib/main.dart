import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/book_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Manager',
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder(
          future: _checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data == true ? HomePage() : LoginPage();
            }
            return CircularProgressIndicator();
          },
        ),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/book_list': (context) => BookListPage(),
      },
    );
  }
}