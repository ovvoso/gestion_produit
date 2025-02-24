import 'dart:convert';

class Product {
  final int? id;
  final String code;
  final String designation;
  final double price;
  final String? description;
  final DateTime? expirationDate;

  Product({
    this.id,
    required this.code,
    required this.designation,
    required this.price,
    this.description,
    this.expirationDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      code: json['code'] as String,
      designation: json['designation'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      expirationDate: json['expiration_date'] != null 
          ? DateTime.parse(json['expiration_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'code': code,
      'designation': designation,
      'price': price,
      if (description != null) 'description': description,
      if (expirationDate != null) 
        'expiration_date': expirationDate!.toIso8601String(),
    };
  }

  Product copyWith({
    int? id,
    String? code,
    String? designation,
    double? price,
    DateTime? expirationDate,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      code: code ?? this.code,
      designation: designation ?? this.designation,
      price: price ?? this.price,
      expirationDate: expirationDate ?? this.expirationDate,
      description: description ?? this.description,
    );
  }
}
