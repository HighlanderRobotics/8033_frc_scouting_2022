///
//  Generated code. Do not modify.
//  source: match_data.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use eventTypeDescriptor instead')
const EventType$json = const {
  '1': 'EventType',
  '2': const [
    const {'1': 'SHOTSUCCESS', '2': 0},
    const {'1': 'SHOTMISS', '2': 1},
    const {'1': 'ROBOTBECOMESIMMOBILE', '2': 2},
    const {'1': 'ROBOTBECOMESMOBILE', '2': 3},
  ],
};

/// Descriptor for `EventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List eventTypeDescriptor = $convert.base64Decode('CglFdmVudFR5cGUSDwoLU0hPVFNVQ0NFU1MQABIMCghTSE9UTUlTUxABEhgKFFJPQk9UQkVDT01FU0lNTU9CSUxFEAISFgoSUk9CT1RCRUNPTUVTTU9CSUxFEAM=');
@$core.Deprecated('Use climbingChallengeDescriptor instead')
const ClimbingChallenge$json = const {
  '1': 'ClimbingChallenge',
  '2': const [
    const {'1': 'DIDNTCLIMB', '2': 0},
    const {'1': 'FAILEDCLIMB', '2': 1},
    const {'1': 'BOTTOMBAR', '2': 2},
    const {'1': 'MIDDLEBAR', '2': 3},
    const {'1': 'HIGHBAR', '2': 4},
    const {'1': 'TRAVERSAL', '2': 5},
  ],
};

/// Descriptor for `ClimbingChallenge`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List climbingChallengeDescriptor = $convert.base64Decode('ChFDbGltYmluZ0NoYWxsZW5nZRIOCgpESUROVENMSU1CEAASDwoLRkFJTEVEQ0xJTUIQARINCglCT1RUT01CQVIQAhINCglNSURETEVCQVIQAxILCgdISUdIQkFSEAQSDQoJVFJBVkVSU0FMEAU=');
@$core.Deprecated('Use matchDataDescriptor instead')
const MatchData$json = const {
  '1': 'MatchData',
  '2': const [
    const {'1': 'uuid', '3': 1, '4': 1, '5': 5, '10': 'uuid'},
    const {'1': 'competitionKey', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'competitionKey', '17': true},
    const {'1': 'matchNumber', '3': 3, '4': 1, '5': 5, '10': 'matchNumber'},
    const {'1': 'teamNumber', '3': 4, '4': 1, '5': 5, '10': 'teamNumber'},
    const {'1': 'scouterId', '3': 5, '4': 1, '5': 5, '10': 'scouterId'},
    const {'1': 'startTime', '3': 6, '4': 1, '5': 11, '6': '.Date', '10': 'startTime'},
    const {'1': 'events', '3': 7, '4': 3, '5': 11, '6': '.Event', '10': 'events'},
    const {'1': 'didDefense', '3': 8, '4': 1, '5': 8, '10': 'didDefense'},
    const {'1': 'notes', '3': 9, '4': 1, '5': 9, '9': 1, '10': 'notes', '17': true},
    const {'1': 'climbingChallenge', '3': 10, '4': 1, '5': 14, '6': '.ClimbingChallenge', '10': 'climbingChallenge'},
  ],
  '8': const [
    const {'1': '_competitionKey'},
    const {'1': '_notes'},
  ],
};

/// Descriptor for `MatchData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchDataDescriptor = $convert.base64Decode('CglNYXRjaERhdGESEgoEdXVpZBgBIAEoBVIEdXVpZBIrCg5jb21wZXRpdGlvbktleRgCIAEoCUgAUg5jb21wZXRpdGlvbktleYgBARIgCgttYXRjaE51bWJlchgDIAEoBVILbWF0Y2hOdW1iZXISHgoKdGVhbU51bWJlchgEIAEoBVIKdGVhbU51bWJlchIcCglzY291dGVySWQYBSABKAVSCXNjb3V0ZXJJZBIjCglzdGFydFRpbWUYBiABKAsyBS5EYXRlUglzdGFydFRpbWUSHgoGZXZlbnRzGAcgAygLMgYuRXZlbnRSBmV2ZW50cxIeCgpkaWREZWZlbnNlGAggASgIUgpkaWREZWZlbnNlEhkKBW5vdGVzGAkgASgJSAFSBW5vdGVziAEBEkAKEWNsaW1iaW5nQ2hhbGxlbmdlGAogASgOMhIuQ2xpbWJpbmdDaGFsbGVuZ2VSEWNsaW1iaW5nQ2hhbGxlbmdlQhEKD19jb21wZXRpdGlvbktleUIICgZfbm90ZXM=');
@$core.Deprecated('Use eventDescriptor instead')
const Event$json = const {
  '1': 'Event',
  '2': const [
    const {'1': 'timeSince', '3': 1, '4': 1, '5': 1, '10': 'timeSince'},
    const {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.EventType', '10': 'type'},
    const {'1': 'position', '3': 3, '4': 1, '5': 5, '10': 'position'},
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode('CgVFdmVudBIcCgl0aW1lU2luY2UYASABKAFSCXRpbWVTaW5jZRIeCgR0eXBlGAIgASgOMgouRXZlbnRUeXBlUgR0eXBlEhoKCHBvc2l0aW9uGAMgASgFUghwb3NpdGlvbg==');
@$core.Deprecated('Use dateDescriptor instead')
const Date$json = const {
  '1': 'Date',
  '2': const [
    const {'1': 'year', '3': 1, '4': 1, '5': 5, '10': 'year'},
    const {'1': 'month', '3': 2, '4': 1, '5': 5, '10': 'month'},
    const {'1': 'day', '3': 3, '4': 1, '5': 5, '10': 'day'},
  ],
};

/// Descriptor for `Date`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dateDescriptor = $convert.base64Decode('CgREYXRlEhIKBHllYXIYASABKAVSBHllYXISFAoFbW9udGgYAiABKAVSBW1vbnRoEhAKA2RheRgDIAEoBVIDZGF5');
