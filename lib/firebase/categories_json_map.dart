
class Categories {
  int no;
  String name;
  String image;

  Categories({required this.no, required this.name, required this.image});

  Map<String, dynamic> toMap() {
    return {
      "category_no": no, 
      "product_category": name,
      "image": image
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    if (map == null) { // Manejar el caso en el que map es nulo, por ejemplo, asignar valores predeterminados
      return Categories(no: 0, name: "No Name", image: "noentry.png");
    }
    
    return Categories(
      no: map["category_no"] ?? 0, // Utiliza el operador ?? para proporcionar un valor predeterminado si el campo es nulo
      name: map["product_category"] ?? "No Name",
      image: map["image"] ?? "No Image"
    );
  }
}