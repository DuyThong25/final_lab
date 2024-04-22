import 'dart:convert';

class ProductModel {
  final int? id;
  final String name;
  final String? desc;
  final String? imageURL;
  final double price;
  final int? categoryID;
  final String? categoryName;

  ProductModel({
    this.id,
    required this.name,
    this.desc,
    this.imageURL,
    required this.price,
    required this.categoryID,
    this.categoryName
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Name': name,
      'ImageURL': imageURL,
      'Description': desc,
      'Price': price,
      'CategoryID': categoryID,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      imageURL: map['imageURL'] ?? '',
      desc: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      categoryID: map['categoryID']!.toInt() ?? 0,
      categoryName: map['categoryName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() => 'Category(id: $id, name: $name, desc: $desc)';
}
