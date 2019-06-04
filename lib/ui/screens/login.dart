
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:msal_js/msal_js.dart';

import 'home.dart';

class LogInRoute extends StatefulWidget {
  LogInRoute({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LogInRouteState createState() => _LogInRouteState();
}

class _LogInRouteState extends State<LogInRoute> {
  final userTFController = TextEditingController();
  final passwordTFController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    userTFController.dispose();
    passwordTFController.dispose();
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: userTFController,
                  style: Theme.of(context).textTheme.caption,
                  decoration: InputDecoration(
                      border: InputBorder.none, 
                      hintText: 'Usuario',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
                ),
                TextField(
                  controller: passwordTFController,
                  style: Theme.of(context).textTheme.caption,
                  decoration: InputDecoration(
                      border: InputBorder.none, 
                      hintText: 'Contraseña',
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
                  obscureText: true,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(12),
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),
                  ],
                ),
                MaterialButton(
                    onPressed: () => logInPressed(),
                    color: Colors.blue,
                    child: Text("Ingresar", style: Theme.of(context).textTheme.button)),
                SizedBox(height: 48.0),
                Text("O", style: Theme.of(context).textTheme.caption),
                MaterialButton(
                    onPressed: () => microsoftLogIn(),
                    color: Colors.blueGrey,
                    child: Text("Microsoft", style: Theme.of(context).textTheme.button)),
                MaterialButton(
                    onPressed: () => googleSignIn(context),
                    color: Colors.blueGrey,
                    child: Text("Google", style: Theme.of(context).textTheme.button)),
              ])),
    );
  }

  Future logInPressed() async {
    if (userTFController.text.length == 0 ||
        passwordTFController.text.length == 0) {
      showAlert('Ingrese el Usuario y la Contraseña');
    } else if (passwordTFController.text.length < 3) {
      showAlert('La Contraseña debe tener más de 2 caracteres');
    } else {
      String data = await getFileData('assets/users.txt');
      List<String> lines = data.split('\n');
      for (var line in lines) {
        String user = line.split(',').first;
        if (user == userTFController.text) {
          String password = line.split(',').last.trim();
          if (password == passwordTFController.text) {
            userTFController.text = "";
            passwordTFController.text = "";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeRoute(user: user)),
            );
            return;
          } else {
            break;
          }
        }
      }

      showAlert('Verifique el Usuario o la Contraseña');
    }
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void showAlert(String alertContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: Text(alertContent),
          actions: <Widget>[
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> googleSignIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _firebaseAuth.signInWithCredential(credential);
    print(user);
    
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeRoute(user: user.displayName, googleSignIn: _googleSignIn,)),
      ); 
    }
  }

  Future<void> microsoftLogIn() async {
    // String idToken;
    // String accessToken;

    // // Instantiate a UserAgentApplication with a client ID and callback
    // final userAgentApplication = new UserAgentApplication('cfee74f1-8c04-40cd-8a33-ef6fa641ed31', null, authCallback);

    // // Login the user via a popup and get an access token
    // final graphScopes = <String>['user.read', 'mail.send'];

    // try {
    //   idToken = await userAgentApplication.loginPopup(graphScopes);

    //   print('Successfully received ID token from login.');

    //   try {
    //     accessToken = await userAgentApplication.acquireTokenSilent(graphScopes);

    //     print('Acquired access token silently.');
    //   } on MsalException {
    //     // Failed to acquire token silently, send an interactive request instead
    //     try {
    //       accessToken = await userAgentApplication.acquireTokenPopup(graphScopes);

    //       print('Acquired access token after interactive prompt.');
    //     } on MsalException catch (ex) {
    //       // Acquire token failure
    //       print(ex);
    //     }
    //   }
    // } on MsalException catch (ex) {
    //   // Login failure
    //   print(ex);
    // }
  }

  // void authCallback(String errorDescription, String token, String error, String tokenType, String userState) {
  //   if (token != null) {
  //     print('Success in auth calback!');
  //   } else {
  //     print('$error:$errorDescription');
  //   }
  // }
}
