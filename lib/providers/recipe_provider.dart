import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class RecipesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Recipe> fast_food_menu = [];

Future<void> FetchRecipes() async {
  isLoading = true;
  notifyListeners();

  final response = await http.get(Uri.parse('http://10.0.2.2:8080/fast_food_menu'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body); // <-- Esto es un Map
    final items = data['fast_food_menu'] as List;

    fast_food_menu = items.map((e) => Recipe.fromJson(e)).toList();
  } else {
    fast_food_menu = [];
  }

  isLoading = false;
  notifyListeners();
}
}
