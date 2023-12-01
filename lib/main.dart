// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:atm/provider/atm_provider.dart';
import 'package:atm/screens/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AtmProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ATM',
        home: HomePage(),
        color: Color.fromARGB(255, 158, 156, 156),
      ),
    ),
  );
}
