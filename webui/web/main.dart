import 'package:angular/angular.dart';
import 'package:grpc/grpc_web.dart';
import 'package:webui/src/auth.dart';
import 'package:webui/src/generated/epantry.pbgrpc.dart';
import 'package:webui/app_component.template.dart' as ng;

import 'main.template.dart' as self;
@GenerateInjector([
  FactoryProvider<Auth>(Auth, authFactory),
  FactoryProvider<ePantryClient>(ePantryClient, ePantryClientFactory),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

ePantryClient ePantryClientFactory(Auth auth) {
  final channel = GrpcWebClientChannel.xhr(Uri.parse('http://localhost:8090'));
  final service = ePantryClient(channel, options: CallOptions(providers: [
        (Map<String,String> metadata, String uri) async {
      var creds = await auth.authenticate();
      print('Bearer ' + creds.idToken.toCompactSerialization());
      metadata['Authorization'] = 'Bearer ' + creds.idToken.toCompactSerialization();
    },
  ]));
  print('created new ePantry service');
  return service;
}

final Auth authSingleton = Auth();
Auth authFactory() {
  return authSingleton;
}

void main() async{
  await authSingleton.init();
  var creds = await authSingleton.authenticate();
  print('user email is: ' + creds.idToken.claims.email);
  runApp(ng.AppComponentNgFactory, createInjector: rootInjector);
}
