
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
  String formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  return {
    'product_no': no,
    'product_name': name,
    'quantity': quantity,
    'gram': gram,
    'image': image,
    'expired_date': formatDate(expiredDate),
    'purchased_date': formatDate(purchasedDate),
  };
}


  // Método estático para crear un objeto MyProductWithNameAndImage a partir de un mapa de Firebase.
static MyProducts fromMap(Map<String, dynamic> map) {
    String parseDate(String dateString) {
      if (dateString == null || dateString.isEmpty) {
        return "0000-00-00";
      } else if (dateString.length == 10) {
        // Fecha en formato "0000-00-00"
        return dateString;
      } else {
        // Fecha en formato "YYYY-MM-DDTHH:mm:ss.sss"
        try {
          DateTime dateTime = DateTime.parse(dateString);
          return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
        } catch (e) {
          // Manejar el error de análisis de fecha
          print("Error parsing date: $e");
          return "0000-00-00";
        }
      }
    }

    return MyProducts(
      no: map['product_no'] ?? '0',
      name: map['product_name'] ?? 'No name',
      quantity: map['quantity'] ?? 0,
      gram: map['gram'] ?? 0,
      image: map['image'] ?? 'no image',
      expiredDate: DateTime.parse(parseDate(map['expired_date'])) ?? DateTime.now(),
      purchasedDate: DateTime.parse(parseDate(map['purchased_date'])) ?? DateTime.now(),
    );
  }
}
