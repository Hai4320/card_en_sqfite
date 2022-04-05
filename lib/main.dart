import 'package:card_en_sqlite/model/english_card_model.dart';
import 'package:card_en_sqlite/provider/card_provider.dart';
import 'package:card_en_sqlite/provider/database.dart';
import 'package:card_en_sqlite/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper dbHelper = DatabaseHelper();


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DatabaseHelper()),
        ChangeNotifierProxyProvider<DatabaseHelper, CardProvider>(
          create: (context) => CardProvider(data: ListCard([]), dbHelper: null),
          update: (context, db, previous) => CardProvider(data: previous!.data, dbHelper: db),
        ),
      ],
      child: const HomePage(),
    );
  }
}
