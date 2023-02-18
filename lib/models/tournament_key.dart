class TournamentKey {
  String name;
  String key;

  TournamentKey(this.name, this.key);

  TournamentKey.fromJson(Map<String, dynamic> json)
      : name = json['localizedDescription'],
        key = json['eventCode'];

  Map<String, dynamic> toJson() => {
        'localizedDescription': name,
        'key': key,
      };
}
