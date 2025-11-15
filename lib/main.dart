import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/settingsPage.dart';
import 'package:weather_app/pages/weather_home.dart';
import 'package:weather_app/weather_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather app',
      theme: ThemeData(
        //fontFamily: 'SpaceMono',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      initialRoute: WeatherHome.routeName,
      routes: {
        WeatherHome.routeName: (context) => WeatherHome(),
        Settingspage.routeName: (context) => Settingspage(),
      },
    );
  }
}
