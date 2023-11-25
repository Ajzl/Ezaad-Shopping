// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

class ProductsModel {
  int id;
  String name;
  String image;
  var price;
  String description;
  String category;


  ProductsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.category,

  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    id: json["id"],
    name: json["title"],
    image: json["thumbnail"],
    price: json["price"],
    description: json["description"],
    category: json["category"],

  );

}
