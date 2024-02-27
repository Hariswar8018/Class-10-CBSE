
class ProductDetails{
  late String Name;

  ProductDetails.fromJson(Map<String, dynamic> json) {
    Name = json['Name'] ?? "u";
  }
}
