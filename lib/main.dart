// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:atm/provider/atm_provider.dart';
import 'package:atm/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (_) => runApp(
      ChangeNotifierProvider(
        create: (context) => AtmProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bankomat',
          home: const HomePage(),
          color: const Color.fromARGB(255, 77, 112, 166),
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 77, 112, 166),
              secondary: Color.fromARGB(255, 230, 233, 237),
            ),
          ),
        ),
      ),
    ),
  );
}
