import 'package:flutter/material.dart';
import 'package:frontend_app/data/providers/CountryProvider.dart';
import 'package:frontend_app/data/providers/UserProvider.dart';
import 'package:frontend_app/data/providers/UserTypeProvider.dart';
import 'package:frontend_app/screens/out-app/ScreenLogin.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider()..init()),
        ChangeNotifierProvider(
          create: (context) => CountryProvider()..init()),
        ChangeNotifierProvider(
          create: (context) => UserTypeProvider()..init()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackerCrawler',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TrackerCrawler Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrackerCrawler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const ScreenLogin(),     
    );
  }
}
