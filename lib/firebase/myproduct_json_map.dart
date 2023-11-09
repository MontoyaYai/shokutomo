
class MyProducts {
  String no;
  String name;
  int quantity;
  int gram;
  String image;
  DateTime expiredDate;
  DateTime purchasedDate;

  MyProducts({
    required this.no,
    required this.name,
    required this.quantity,
    required this.gram,
    required this.image,
    required this.expiredDate,
    required this.purchasedDate,
  });

  // Método para convertir un objeto MyProductWithNameAndImage a un mapa que se puede guardar en Firebase.
  Map<String, dynamic> toMap() {
    return {
      'product_no': no,
      'product_name': name,
      'quantity': quantity,
      'gram': gram,
      'image': image,
      'expired_date': expiredDate.toIso8601String(),
      'purchased_date': purchasedDate.toIso8601String(),
    };
  }

  // Método estático para crear un objeto MyProductWithNameAndImage a partir de un mapa de Firebase.
  static MyProducts fromMap(Map<String, dynamic> map) {
    return MyProducts(
      no: map['product_no'] ?? '0',
      name: map['product_name'] ?? 'No name',
      quantity: map['quantity']?? 0,
      gram: map['gram'] ?? 0,
      image: map['image'] ?? 'no image',
      expiredDate: DateTime.parse(map['expired_date']) ?? DateTime.now(),
      purchasedDate: DateTime.parse(map['purchased_date'])?? DateTime.now(),
    );
  }
}
