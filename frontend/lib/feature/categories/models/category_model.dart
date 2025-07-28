class CategoryModel {
  final int id;
  final String name;
  final String descripcion;
  final double precio;
  final String imageUrl;

  CategoryModel({required this.id, required this.name, required this.descripcion, required this.precio, required this.imageUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      descripcion: json['descripcion'],
      precio: json['precio'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}