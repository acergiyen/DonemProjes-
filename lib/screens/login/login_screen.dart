import 'dart:ui';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter/material.dart';
import 'package:mobilerollcall/auth.dart';
import 'package:mobilerollcall/data/database_helper.dart';
import 'package:mobilerollcall/models/user.dart';
import 'package:mobilerollcall/screens/login/login_screen_presenter.dart';


var Email = 'acergiyen@gmail.com';
var PasswordHash='Dgsdy16flsm539';
class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String PasswordHash;
  String Email;
  LoginScreenPresenter _presenter;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(Email,PasswordHash);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) {

    if(state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN"),
      color: Theme.of(context).accentColor,
      elevation: 4.0,
      splashColor: Colors.blueGrey,
    );

    var forgotBtn = new FlatButton(
      onPressed: null,
      child: new Text("FORGOT YOUR PASSWORD ? "),
      color: Theme.of(context).accentColor,
      splashColor: Colors.blueGrey ,);


    var loginForm = new Column(
      children: <Widget>[

        new Text(
          "Mobile Roll Call",

          textScaleFactor: 2.0,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic
          ),


        ),

        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[

              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => Email = val,
                  validator: (val) {
                    return val.length < 10
                        ? "Email must have at least 10 characters"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Email"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => PasswordHash = val,
                  decoration: InputDecoration(labelText: "Password"),


                ),
              ),
            ],
          ),

        ),

        _isLoading ? new CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/login_background.jpg"),
              fit: BoxFit.cover),
        ),
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 0.0, sigmaY: 10.0),
              child: new Container(
                child: loginForm,
                height: 480.0,
                width: 400.0,
                decoration: new BoxDecoration(
                    color: Colors.redAccent.shade200.withOpacity(0.2)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
}