class Scouter {
  int id;
  String name;

  Scouter({required this.id, required this.name});

  factory Scouter.fromJson(List<dynamic> json) {
    return Scouter(
      id: json[0],
      name: json[1],
    );
  }

  List toJson() => [id, name];
}
