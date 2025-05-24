class Recipe {
  final String name;
  final String author;
  final String imageLink;
  final List<String> recipeSteps;

  Recipe({
    required this.name,
    required this.author,
    required this.imageLink,
    required this.recipeSteps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      author: json['author'],
      imageLink: json['image_link'], // ✅ Coincide con el JSON
      recipeSteps: List<String>.from(json['recipe']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
      'image_link': imageLink, // ✅ Coincide con el JSON
      'recipe': recipeSteps,
    };
  }

  @override
  String toString() {
    return 'Recipe{name: $name, author: $author, imageLink: $imageLink, recipe: $recipeSteps}';
  }
}