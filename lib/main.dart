import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/providers/recipe_provider.dart';
import 'package:recipe_book/screens/home_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipesProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hola Mundo',
        home: const RecipeBook(),
      ),
    );
  }
}

class RecipeBook extends StatelessWidget {
  const RecipeBook({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'RecipeBook',
            style: TextStyle(color: Colors.white),
          ),
       bottom: const TabBar(
  indicatorColor: Colors.white,
  labelColor: Colors.white,
  unselectedLabelColor: Colors.white,
  tabs: [
    Tab(icon: Icon(Icons.home), text: 'Home'),
    Tab(icon: Icon(Icons.favorite), text: 'Favoritos'),
    Tab(icon: Icon(Icons.book), text: 'Recetas'),
    Tab(icon: Icon(Icons.settings), text: 'Ajustes'),
  ],
),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            // Otros tabs si los necesitas...
            Center(child: Text("Tab 2")),
            Center(child: Text("Tab 3")),
            Center(child: Text("Tab 4")),
          ],
        ),
      ),
    );
  }
}

