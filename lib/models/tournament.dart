class Tournament {
  String name;
  String key;

  Tournament({
    required this.name,
    required this.key,
  });

  Tournament.fromJson(Map<String, dynamic> json)
      : name = json['localizedDescription'],
        key = json['key'];

  Map<String, dynamic> toJson() => {
        'localizedDescription': name,
        'key': key,
      };
}
