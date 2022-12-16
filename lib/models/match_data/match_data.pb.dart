///
//  Generated code. Do not modify.
//  source: match_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'match_data.pbenum.dart';

export 'match_data.pbenum.dart';

class MatchData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MatchData', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uuid', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'competitionKey', protoName: 'competitionKey')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'matchNumber', $pb.PbFieldType.O3, protoName: 'matchNumber')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'teamNumber', $pb.PbFieldType.O3, protoName: 'teamNumber')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'scouterId', $pb.PbFieldType.O3, protoName: 'scouterId')
    ..aOM<Date>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startTime', protoName: 'startTime', subBuilder: Date.create)
    ..pc<Event>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'events', $pb.PbFieldType.PM, subBuilder: Event.create)
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'didDefense', protoName: 'didDefense')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notes')
    ..e<ClimbingChallenge>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'climbingChallenge', $pb.PbFieldType.OE, protoName: 'climbingChallenge', defaultOrMaker: ClimbingChallenge.DIDNTCLIMB, valueOf: ClimbingChallenge.valueOf, enumValues: ClimbingChallenge.values)
    ..hasRequiredFields = false
  ;

  MatchData._() : super();
  factory MatchData({
    $core.int? uuid,
    $core.String? competitionKey,
    $core.int? matchNumber,
    $core.int? teamNumber,
    $core.int? scouterId,
    Date? startTime,
    $core.Iterable<Event>? events,
    $core.bool? didDefense,
    $core.String? notes,
    ClimbingChallenge? climbingChallenge,
  }) {
    final _result = create();
    if (uuid != null) {
      _result.uuid = uuid;
    }
    if (competitionKey != null) {
      _result.competitionKey = competitionKey;
    }
    if (matchNumber != null) {
      _result.matchNumber = matchNumber;
    }
    if (teamNumber != null) {
      _result.teamNumber = teamNumber;
    }
    if (scouterId != null) {
      _result.scouterId = scouterId;
    }
    if (startTime != null) {
      _result.startTime = startTime;
    }
    if (events != null) {
      _result.events.addAll(events);
    }
    if (didDefense != null) {
      _result.didDefense = didDefense;
    }
    if (notes != null) {
      _result.notes = notes;
    }
    if (climbingChallenge != null) {
      _result.climbingChallenge = climbingChallenge;
    }
    return _result;
  }
  factory MatchData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MatchData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MatchData clone() => MatchData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MatchData copyWith(void Function(MatchData) updates) => super.copyWith((message) => updates(message as MatchData)) as MatchData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MatchData create() => MatchData._();
  MatchData createEmptyInstance() => create();
  static $pb.PbList<MatchData> createRepeated() => $pb.PbList<MatchData>();
  @$core.pragma('dart2js:noInline')
  static MatchData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MatchData>(create);
  static MatchData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get uuid => $_getIZ(0);
  @$pb.TagNumber(1)
  set uuid($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUuid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get competitionKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set competitionKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCompetitionKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompetitionKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get matchNumber => $_getIZ(2);
  @$pb.TagNumber(3)
  set matchNumber($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMatchNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearMatchNumber() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get teamNumber => $_getIZ(3);
  @$pb.TagNumber(4)
  set teamNumber($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTeamNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearTeamNumber() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get scouterId => $_getIZ(4);
  @$pb.TagNumber(5)
  set scouterId($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasScouterId() => $_has(4);
  @$pb.TagNumber(5)
  void clearScouterId() => clearField(5);

  @$pb.TagNumber(6)
  Date get startTime => $_getN(5);
  @$pb.TagNumber(6)
  set startTime(Date v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStartTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartTime() => clearField(6);
  @$pb.TagNumber(6)
  Date ensureStartTime() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.List<Event> get events => $_getList(6);

  @$pb.TagNumber(8)
  $core.bool get didDefense => $_getBF(7);
  @$pb.TagNumber(8)
  set didDefense($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasDidDefense() => $_has(7);
  @$pb.TagNumber(8)
  void clearDidDefense() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get notes => $_getSZ(8);
  @$pb.TagNumber(9)
  set notes($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasNotes() => $_has(8);
  @$pb.TagNumber(9)
  void clearNotes() => clearField(9);

  @$pb.TagNumber(10)
  ClimbingChallenge get climbingChallenge => $_getN(9);
  @$pb.TagNumber(10)
  set climbingChallenge(ClimbingChallenge v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasClimbingChallenge() => $_has(9);
  @$pb.TagNumber(10)
  void clearClimbingChallenge() => clearField(10);
}

class Event extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Event', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeSince', $pb.PbFieldType.OD, protoName: 'timeSince')
    ..e<EventType>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: EventType.SHOTSUCCESS, valueOf: EventType.valueOf, enumValues: EventType.values)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'position', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Event._() : super();
  factory Event({
    $core.double? timeSince,
    EventType? type,
    $core.int? position,
  }) {
    final _result = create();
    if (timeSince != null) {
      _result.timeSince = timeSince;
    }
    if (type != null) {
      _result.type = type;
    }
    if (position != null) {
      _result.position = position;
    }
    return _result;
  }
  factory Event.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Event.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Event clone() => Event()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Event copyWith(void Function(Event) updates) => super.copyWith((message) => updates(message as Event)) as Event; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Event create() => Event._();
  Event createEmptyInstance() => create();
  static $pb.PbList<Event> createRepeated() => $pb.PbList<Event>();
  @$core.pragma('dart2js:noInline')
  static Event getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Event>(create);
  static Event? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get timeSince => $_getN(0);
  @$pb.TagNumber(1)
  set timeSince($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimeSince() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimeSince() => clearField(1);

  @$pb.TagNumber(2)
  EventType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(EventType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get position => $_getIZ(2);
  @$pb.TagNumber(3)
  set position($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => clearField(3);
}

class Date extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Date', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'year', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'month', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'day', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Date._() : super();
  factory Date({
    $core.int? year,
    $core.int? month,
    $core.int? day,
  }) {
    final _result = create();
    if (year != null) {
      _result.year = year;
    }
    if (month != null) {
      _result.month = month;
    }
    if (day != null) {
      _result.day = day;
    }
    return _result;
  }
  factory Date.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Date.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Date clone() => Date()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Date copyWith(void Function(Date) updates) => super.copyWith((message) => updates(message as Date)) as Date; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Date create() => Date._();
  Date createEmptyInstance() => create();
  static $pb.PbList<Date> createRepeated() => $pb.PbList<Date>();
  @$core.pragma('dart2js:noInline')
  static Date getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Date>(create);
  static Date? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get year => $_getIZ(0);
  @$pb.TagNumber(1)
  set year($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasYear() => $_has(0);
  @$pb.TagNumber(1)
  void clearYear() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get month => $_getIZ(1);
  @$pb.TagNumber(2)
  set month($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMonth() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonth() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get day => $_getIZ(2);
  @$pb.TagNumber(3)
  set day($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDay() => clearField(3);
}

