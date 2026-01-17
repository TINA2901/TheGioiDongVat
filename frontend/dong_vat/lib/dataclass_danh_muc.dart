class DataclassDanhMuc {
  final int id;
  final String name;
  final String description;

  DataclassDanhMuc({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DataclassDanhMuc.fromJson(Map<String, dynamic> json) {
    return DataclassDanhMuc(
      id: json["id"],
      name: json["name"],
      description: json["description"],
    );
  }
}
