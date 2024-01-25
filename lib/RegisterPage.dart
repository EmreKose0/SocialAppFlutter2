
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/LogInPage.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterPage(),
    );
  }
}
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  String? _confirmPassword;
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty!';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters!';
    }
    return null;
  }
  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match!';
    }
    return null;
  }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Burada API'ye gönderilecek isteğinizi oluşturabilirsiniz
      // Örneğin, bir POST isteği gösterelim:
      try {
    
          final url = Uri.parse('http://192.168.1.6:8000/register');
          final response = await http.post(
          url,
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',    
          },
          body: jsonEncode(<String, String>{
            'nameSurname': _name!,
            'email': _email!,
            'password': _password!,
          },
        ));
        if (response.statusCode == 200) {
          // Başarılı bir şekilde kayıt yapıldı
          print('Kayıt başarıyla yapıldı');
          _showSnackBar('Success');
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogInPage()),
    );
          // Başka bir sayfaya yönlendirme yapabilirsiniz
        } else {
          // Kayıt sırasında bir hata oluştu
          _showSnackBar('Failed');
          print('Kayıt sırasında hata oluştu');
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name Surname',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Name & Surname!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please Enter a Valid E-mail!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  controller: _passwordController,
                  validator: _validatePassword,
                  onSaved: (value) {
                    _password = value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password Confirm',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateConfirmPassword,
                  onSaved: (value) {
                    _confirmPassword = value;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
