class ProductModel {
  final int id;
  final String name;
  final String price;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, Object?> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.id == id &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode => Object.hash(id, name, price);
}
