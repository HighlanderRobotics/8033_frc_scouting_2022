class TournamentKey {
  String name;
  String eventCode;

  TournamentKey(this.name, this.eventCode);

  TournamentKey.fromJson(Map<String, dynamic> json)
      : name = json['localizedDescription'],
        eventCode = json['eventCode'];

  Map<String, dynamic> toJson() => {
        'localizedDescription': name,
        'eventCode': eventCode,
      };
}
