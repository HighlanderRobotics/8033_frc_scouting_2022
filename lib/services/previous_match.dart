import 'match_data/match_data.dart';

class MatchInfo {
  List<MatchData> validMatches;
  int numberOfInvalidFiles;

  MatchInfo(this.validMatches, this.numberOfInvalidFiles);
}
