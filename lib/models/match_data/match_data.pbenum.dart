///
//  Generated code. Do not modify.
//  source: match_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class EventType extends $pb.ProtobufEnum {
  static const EventType SHOTSUCCESS = EventType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SHOTSUCCESS');
  static const EventType SHOTMISS = EventType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SHOTMISS');
  static const EventType ROBOTBECOMESIMMOBILE = EventType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROBOTBECOMESIMMOBILE');
  static const EventType ROBOTBECOMESMOBILE = EventType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ROBOTBECOMESMOBILE');

  static const $core.List<EventType> values = <EventType> [
    SHOTSUCCESS,
    SHOTMISS,
    ROBOTBECOMESIMMOBILE,
    ROBOTBECOMESMOBILE,
  ];

  static final $core.Map<$core.int, EventType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EventType? valueOf($core.int value) => _byValue[value];

  const EventType._($core.int v, $core.String n) : super(v, n);
}

class ClimbingChallenge extends $pb.ProtobufEnum {
  static const ClimbingChallenge DIDNTCLIMB = ClimbingChallenge._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DIDNTCLIMB');
  static const ClimbingChallenge FAILEDCLIMB = ClimbingChallenge._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FAILEDCLIMB');
  static const ClimbingChallenge BOTTOMBAR = ClimbingChallenge._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BOTTOMBAR');
  static const ClimbingChallenge MIDDLEBAR = ClimbingChallenge._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MIDDLEBAR');
  static const ClimbingChallenge HIGHBAR = ClimbingChallenge._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HIGHBAR');
  static const ClimbingChallenge TRAVERSAL = ClimbingChallenge._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRAVERSAL');

  static const $core.List<ClimbingChallenge> values = <ClimbingChallenge> [
    DIDNTCLIMB,
    FAILEDCLIMB,
    BOTTOMBAR,
    MIDDLEBAR,
    HIGHBAR,
    TRAVERSAL,
  ];

  static final $core.Map<$core.int, ClimbingChallenge> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ClimbingChallenge? valueOf($core.int value) => _byValue[value];

  const ClimbingChallenge._($core.int v, $core.String n) : super(v, n);
}

