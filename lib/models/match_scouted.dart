class MatchScouted {
  final bool status;
  final String matchKey;

  MatchScouted({required this.status, required this.matchKey});

  factory MatchScouted.fromJson(Map<String, dynamic> json) {
    return MatchScouted(
      status: json['status'] as bool,
      matchKey: json['matchKey'] as String,
    );
  }
}
