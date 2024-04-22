import 'dart:convert';

class CategoryModel {
  final int? id;
  final String name;
  final String desc;
  final String imageURL;

  CategoryModel({
    this.id,
    required this.name,
    required this.desc,
    required this.imageURL,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Name': name,
      'ImageURL': imageURL,
      'Description': desc,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      imageURL: map['imageURL'] ?? '',
      desc: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'Category(id: $id, name: $name, desc: $desc)';
}
