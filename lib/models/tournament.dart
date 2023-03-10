class Tournament {
  String name;
  String key;

  Tournament(this.name, this.key);

  Tournament.fromJson(Map<String, dynamic> json)
      : name = json['localizedDescription'],
        key = json['eventCode'];

  Map<String, dynamic> toJson() => {
        'localizedDescription': name,
        'key': key,
      };
}
