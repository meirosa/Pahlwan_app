class Pahlawan {
  final int? id;
  final String name;
  final String category;
  final String description;
  final String? imagePath;

  Pahlawan({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'imagePath': imagePath,
    };
  }

  factory Pahlawan.fromMap(Map<String, dynamic> map) {
    return Pahlawan(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      imagePath: map['imagePath'],
    );
  }
}
