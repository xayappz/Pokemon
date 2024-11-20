import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon/screens/detail_screen.dart';
import 'package:pokemon/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon Cards',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/detail', page: () => PokemonDetailScreen()),
      ],
    );
  }
}
