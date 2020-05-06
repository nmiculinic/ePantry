///
//  Generated code. Do not modify.
//  source: epantry.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'google/protobuf/empty.pb.dart' as $0;
import 'epantry.pb.dart' as $1;
export 'epantry.pb.dart';

class ePantryClient extends $grpc.Client {
  static final _$version = $grpc.ClientMethod<$0.Empty, $1.APIVersion>(
      '/api.v1.epantry.ePantry/Version',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.APIVersion.fromBuffer(value));

  ePantryClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$1.APIVersion> version($0.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$version, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class ePantryServiceBase extends $grpc.Service {
  $core.String get $name => 'api.v1.epantry.ePantry';

  ePantryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.APIVersion>(
        'Version',
        version_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.APIVersion value) => value.writeToBuffer()));
  }

  $async.Future<$1.APIVersion> version_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return version(call, await request);
  }

  $async.Future<$1.APIVersion> version(
      $grpc.ServiceCall call, $0.Empty request);
}
