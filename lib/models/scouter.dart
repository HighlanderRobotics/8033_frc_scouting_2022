class Scouter {
  int id;
  String name;

  Scouter({required this.id, required this.name});

  factory Scouter.fromJson(Map<String, dynamic> json) {
    return Scouter(
      id: json["id"],
      name: json["name"],
    );
  }

  Map toJson() => {"id": id, "name": name};
}
