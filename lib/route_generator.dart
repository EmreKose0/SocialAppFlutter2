
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'LogInPage.dart';
import 'RegisterPage.dart';



class RouteGenerator{
  static Route<dynamic>? routeGenerator(RouteSettings settings){     

switch(settings.name){
  case '/Home':              
        final String _userName = settings.arguments as String;                                          
        return MaterialPageRoute(builder: (context) => HomePage(userName: _userName,),);   
    
  case '/':
        return MaterialPageRoute(builder: (context) => LogInPage());  

  case '/Register':
        return MaterialPageRoute(builder: (context)=> RegisterPage());

  
  

}
  }
}