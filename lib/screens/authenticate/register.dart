import 'package:flutter_scanner/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scanner/shared/constants.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String userName = '';
  String userSection = '';
  final _formKey = GlobalKey<FormState>();
  String section;

  FocusNode registerFocusNode;

  @override
  void initState() {
    super.initState();
    registerFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    registerFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          elevation: 0.0,
          title: Center(child: Text('Sign in to File Track System')),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(hintText: 'Enter email'),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration:
                        new InputDecoration(hintText: 'Enter the password'),
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration:
                        new InputDecoration(hintText: 'Enter User Name'),
                    onChanged: (val) {
                      setState(() => userName = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  // TextFormField(
                  //   decoration:
                  //       new InputDecoration(hintText: ''),
                  //   onChanged: (val) {
                  //     setState(() => userSection = val);
                  //   },
                  // ),
                  DropdownButtonFormField(
                    hint: Text('Enter User Section'),
                    value: section,
                    items: sectionsList
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        userSection = val;
                        registerFocusNode.requestFocus();
                      });
                      print(val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.green)),
                      color: Colors.blue[400],
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        // print(email);
                        // print(password);
                        await _auth.signInWithEmailAndPassword(email, password);
                        //Toast.show(await _auth.currentError(), context);
                        //ToastView.createView(_auth.currentError(), context, 1, 0, Colors.grey, Colors.white, 10, Border.symmetric(vertical: BorderSide.none, horizontal: BorderSide.none));
                      }),
                  SizedBox(width: 20, height: 20),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 80, 8, 8),
                    child: RaisedButton(
                        focusNode: registerFocusNode,
                        color: Colors.blue[400],
                        child: Text(
                          'Register Now',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          // print(email);
                          // print(password);
                          await _auth.registerWithEmailAndPassword(
                              email, password, userName, userSection);
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
