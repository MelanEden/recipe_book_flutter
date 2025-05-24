import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/providers/recipe_provider.dart';
import 'package:recipe_book/screens/recipe_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Esperar a que el widget esté montado antes de usar el contexto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecipesProvider>(context, listen: false).FetchRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RecipesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.fast_food_menu.isEmpty) {
            return const Center(child: Text('No recipe found'));
          } else {
            return ListView.builder(
              itemCount: provider.fast_food_menu.length,
              itemBuilder: (context, index) {
                return _RecipesCard(context, provider.fast_food_menu[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showBottom(context),
      ),
    );
  }

  Future<void> _showBottom(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // <- permite que se use más altura si es necesario
      builder:
          (contexto) => Container(
            width: MediaQuery.of(context).size.width,
            height: maxHeight,
            color: Colors.white,
            child: const SingleChildScrollView(
              // <- para evitar overflow
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: ReciperForm()),
              ),
            ),
          ),
    );
  }

  Widget _RecipesCard(BuildContext context, dynamic recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(recipename: recipe.name),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 125,
          child: Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 125,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      recipe.imageLink,
                      width: 80, // Tamaño fijo horizontal
                      height: 80, // Tamaño fijo vertical
                      fit:
                          BoxFit
                              .cover, // Escala y recorta para que llene sin deformarse
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, size: 80);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 26),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(recipe.name, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 4),
                    SizedBox(
                      height: 2,
                      width: 75,
                      child: ColoredBox(color: Colors.blue),
                    ),
                   Text('By ${recipe.author}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReciperForm extends StatelessWidget {
  const ReciperForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _recipename = TextEditingController();
    final TextEditingController _recipechef = TextEditingController();
    final TextEditingController _recipeIngredientes = TextEditingController();
    final TextEditingController _recipetime = TextEditingController();
    final TextEditingController _recipeIMG = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Agrega nueva receta',
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipename,
              label: 'Nombre de la receta',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nombre de la receta';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipechef,
              label: 'Nombre del chef',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nombre del chef';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              maxLines: 4,
              controller: _recipeIngredientes,
              label: 'Ingredientes',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el/los ingredientes';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipetime,
              label: 'Tiempo de preparación',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el tiempo de la receta';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeIMG,
              label: 'Imagen de la receta',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la imagen de la receta';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Quicksand', color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      home: Scaffold(
        appBar: AppBar(title: Text('Recetas')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              openInBrowser('http://10.0.2.2:8080/fast_food_menu');
            },
            child: Text('Abrir receta en navegador'),
          ),
        ),
      ),
    );
  }
}

// Esta es tu función para abrir el navegador
void openInBrowser(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'No se pudo abrir $url';
  }
}
