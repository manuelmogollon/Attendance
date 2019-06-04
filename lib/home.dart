import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeRoute extends StatelessWidget {
  HomeRoute({Key key, this.user, this.googleSignIn}) : super(key: key);

  final String user;
  final GoogleSignIn googleSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        //automaticallyImplyLeading: false,
      ),
      body: Center (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Bienvenido ' + user,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Roboto"
                )),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                if (googleSignIn != null)
                {
                  googleSignIn.signOut();
                }
                Navigator.pop(context);
              },
              child: Text('Cerrar Sesión',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: "Roboto",
                  )),
            )
          ], 
        ),  
      )    
    );
  }
}
