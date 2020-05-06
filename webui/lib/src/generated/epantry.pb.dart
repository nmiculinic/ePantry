///
//  Generated code. Do not modify.
//  source: epantry.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class APIVersion extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('APIVersion', package: const $pb.PackageName('api.v1.epantry'), createEmptyInstance: create)
    ..aOS(1, 'version')
    ..hasRequiredFields = false
  ;

  APIVersion._() : super();
  factory APIVersion() => create();
  factory APIVersion.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory APIVersion.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  APIVersion clone() => APIVersion()..mergeFromMessage(this);
  APIVersion copyWith(void Function(APIVersion) updates) => super.copyWith((message) => updates(message as APIVersion));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static APIVersion create() => APIVersion._();
  APIVersion createEmptyInstance() => create();
  static $pb.PbList<APIVersion> createRepeated() => $pb.PbList<APIVersion>();
  @$core.pragma('dart2js:noInline')
  static APIVersion getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<APIVersion>(create);
  static APIVersion _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);
}
