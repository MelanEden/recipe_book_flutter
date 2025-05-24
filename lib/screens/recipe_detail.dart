import 'package:flutter/material.dart';

class RecipeDetail extends StatelessWidget {
  final String recipename;
  const RecipeDetail({super.key, required this.recipename});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text(recipename),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), color: Colors.white,
        onPressed:() {Navigator.pop(context);}),
      ),

    );
  }
}