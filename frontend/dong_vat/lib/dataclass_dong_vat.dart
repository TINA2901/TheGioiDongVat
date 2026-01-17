class DataclassDongVat {
  final int id;
  final int category_id;
  final String name;
  final String description;
  final String habitat;
  final String diet;
  final String status;
  final String avatar_url;

  DataclassDongVat({
    required this.id,
    required this.category_id,
    required this.name,
    required this.description,
    required this.habitat,
    required this.diet,
    required this.status,
    required this.avatar_url,
  });

  factory DataclassDongVat.fromJson(Map<String, dynamic> json) {
    return DataclassDongVat(
      id: json["id"],
      category_id: json["category_id"],
      name: json["name"],
      description: json["description"],
      habitat: json["habitat"],
      diet: json["diet"],
      status: json["status"],
      avatar_url: json["avatar_url"],
    );
  }
}
