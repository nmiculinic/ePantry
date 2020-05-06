import 'package:openid_client/openid_client.dart';
import 'package:openid_client/openid_client_browser.dart';

class Auth {
  final Uri APIServerURI= Uri.parse('http://localhost:8090');
  final Uri redirectURI = Uri.parse('http://localhost:8080');
  final scopes = ['openid', 'email'];
  final clientID = '640570493642-p10tov8pbr0b5kplri6to2fumbkrf397.apps.googleusercontent.com';
  final OIDCDiscoveryURI = Uri.parse('https://accounts.google.com');

  Issuer issuer;
  Client client;
  Authenticator authenticator;

  Future<Credential> authenticate() async {
    if (authenticator == null) {
      await init();
    }
    var c = await authenticator.credential;
    if (
    c == null ||
        c.idToken.claims.expiry.isBefore(
            DateTime.now().subtract(Duration(seconds: 5))
        )
    ) {
      authenticator.authorize();
      throw 'should be redirected by now';
    }
    return c;
  }

  Future<void> init() async {
    issuer = await Issuer.discover(OIDCDiscoveryURI);
    client = Client(issuer, clientID);
    authenticator = Authenticator(client, scopes: scopes);
    authenticator.flow.redirectUri = redirectURI;
    print('initialized auth object');
  }
}
