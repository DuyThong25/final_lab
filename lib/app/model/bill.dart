class BillModel {
  String id;
  String fullName;
  String dateCreated;
  double total;

  BillModel(
      {required this.id,
      required this.fullName,
      required this.dateCreated,
      required this.total});

  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      dateCreated: map['dateCreated'] ?? '',
      total: map['total']?.toDouble() ?? 0.0,
    );
  }
}

class BillDetailModel {
  int productID;
  String productName;
  String? imageURL;
  double price;
  int count;
  double total;

  BillDetailModel({
    required this.productID,
    required this.productName,
    this.imageURL,
    required this.price,
    required this.count,
    required this.total,
  });

  factory BillDetailModel.fromMap(Map<String, dynamic> map) {
    return BillDetailModel(
      productID: map['productID'] ?? 0,
      productName: map['productName'] ?? '',
      imageURL: map['imageURL'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      count: map['count']?.toInt() ?? 0,
      total: map['total']?.toDouble() ?? 0.0,
    );
  }
}
