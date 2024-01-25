import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      );
  }
}
class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}
class _LogInPageState extends State<LogInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _email;
  String? _password;
  String? _userName;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final url = Uri.parse('http://192.168.1.6:8000/login');
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': _email!,
            'password': _password!,
          }),
        );

        if (response.statusCode == 200) {
          print('Giriş Başarılı');
          await _getUserName();
          _showSnackBar('Success');
          Navigator.pushNamed(context, '/Home', arguments: _userName);

        } else {
          _showSnackBar('Failed');
          print('Giriş sırasında hata oluştu');
        }
      } catch (e) {
        print('Hata: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _getUserName() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final url = Uri.parse('http://192.168.1.6:8000/getUserName');
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': _email!,
          }),
        );

        if (response.statusCode == 200) {
          print('Veri Alındı');
          final Map<String, dynamic> data = jsonDecode(response.body);
          _userName = data['userName'].toString();
        } else {
          _showSnackBar('Failed');
          print('Veri alınırken hata oluştu');
        }
      } catch (e) {
        print('Hata: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('lib/assets/Nttlogo.PNG'),
                ),
                SizedBox( height: 20),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  onSaved: (value) {
                    _email = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please Enter a Valid E-mail!';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  obscureText: true,
                  onSaved: (value) {
                    _password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Log in'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Register');
                },
                child: Text('Register?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}