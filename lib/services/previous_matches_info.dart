import 'match_data/match_data.dart';

class PreviousMatchesInfo {
  List<MatchData> validMatches;
  int numberOfInvalidFiles;

  PreviousMatchesInfo(this.validMatches, this.numberOfInvalidFiles);
}
