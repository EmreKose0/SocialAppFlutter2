import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as datatTimePicker;

class HomePage extends StatefulWidget {
  final String? userName;

  HomePage({required this.userName, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedLocation;
  String? selectedPurpose;
  String? selectedHobby;
  bool isLoading = false;
  String? matchedUserName;

  List<String> locationOptions = ['Online', 'NTT Nidakule', 'BSH Buyaka'];
  List<String> purposeOptions = ['Game', 'Talk', 'Need Help'];
  List<String> talkOptions = [
    'Computer programming',
    'Fitness training',
    'Soccer',
    'Camping',
    'Cooking',
    'Dancing'
  ];
  List<String> gameOptions = ['Foosball', 'Playstation', 'Chess'];
  List<String> helpOptions = ['Career', 'Programming', 'Analyst', 'SAP'];
  List<String> currentOptions = [];

  DateTime selectStartTime = DateTime.now();
  DateTime selectFinishTime = DateTime.now();

  
Future<void> _showLoadingDialog() async {
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Finding Match..."),
          ],
        ),
      );
    },
  );
  await Future.delayed(Duration(seconds: 5));
  if (matchedUserName != null) {
    Navigator.of(context).pop();
    _showMatchResultDialog();
  }
}


  Future<void> _showMatchResultDialog() async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            "Match Result",
            style: TextStyle(color: Colors.green, fontSize: 20),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/assets/profile_image.jpg'),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: 60,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: AssetImage('lib/assets/vs2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/assets/pp2.jpeg'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Matched with ",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  matchedUserName.toString(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Location: " + selectedLocation.toString(), style: TextStyle(fontSize: 16)),
            Text(selectedHobby.toString(), style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                print("bi sonraki pop up");
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      );
    },
  );
}

  Future<void> _performMatching() async {
    try {
      await sendData();
      _showLoadingDialog();

      setState(() {
        isLoading = true;
      });


      print(isLoading.toString());
      setState(() {
        isLoading = false;
      });
      print("showmatchresult tan üstteyiz");
      print(isLoading.toString());

    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print("Error: $e");
    }
  }

  Future<Map<String, dynamic>?> performLogin(
      String email, String password) async {
    final url = Uri.parse('http://192.168.1.6:8000/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Performlogin basarılı');
      return data;
    } else {
      return null;
    }
  }

  void _selectStartTime(BuildContext context) {
    datatTimePicker.DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      showSecondsColumn: false,
      onChanged: (time) {
        print('change $time');
      },
      onConfirm: (time) {
        selectStartTime = time;
        print(selectStartTime);
      },
      currentTime: DateTime.now(),
      locale: datatTimePicker.LocaleType.en,
    );
  }

  void _selectFinishTime(BuildContext context) {
    datatTimePicker.DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      showSecondsColumn: false,
      onChanged: (time) {
        print('change $time');
      },
      onConfirm: (time) {
        selectFinishTime = time;
        print(selectFinishTime);
      },
      currentTime: DateTime.now(),
      locale: datatTimePicker.LocaleType.en,
    );
  }

  String? _validationHomePage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a value!';
    }
    return null;
  }

  Future<bool> sendData() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final url = Uri.parse('http://192.168.1.6:8000/add_data');
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'userName': widget.userName ?? '',
            'location': selectedLocation ?? '',
            'purpose': selectedPurpose ?? '',
            'hobbies': selectedHobby ?? '',
            'startTime': selectStartTime.toString() ?? '',
            'finishTime': selectFinishTime.toString() ?? ''
          }),
        );

        if (response.statusCode == 200) {
          print('Veri ekleme işlemi başarılı: ${response.body}');
          final json = "[" + response.body + "]";
          final List<dynamic> data2 = jsonDecode(json);
          print(data2);
          print(data2[0]);
          final Map<String, dynamic> firstItem = data2[0];
          print(firstItem);
          if (data2[0].isNotEmpty) {
            print("if blogu icindeyiz");
            final List<dynamic> matchedUsers = firstItem['matchedUsers'];
            print(matchedUsers[0]['matchedUserName']);
            matchedUserName = matchedUsers[0]['matchedUserName'];

            print(matchedUserName);
            return true;
          } else {
            print('Eşleşen kullanıcı adı bulunamadı.');
            return false;
          }
        }
      }
      return false;
    } catch (e) {
      print('Hata: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedPurpose != null) {
      if (selectedPurpose == 'Game') {
        currentOptions = gameOptions;
      } else if (selectedPurpose == 'Talk') {
        currentOptions = talkOptions;
      } else if (selectedPurpose == 'Need Help') {
        currentOptions = helpOptions;
      } else {
        currentOptions = talkOptions;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('SocialApp'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage:
                    AssetImage('lib/assets/profile_image.jpg'),
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    'lib/assets/profile_image.jpg',
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  widget.userName.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                validator: _validationHomePage,
                value: selectedLocation,
                items: locationOptions
                    .map((location) => DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Locations',
                  labelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                validator: _validationHomePage,
                value: selectedPurpose,
                items: purposeOptions
                    .map((purpose) => DropdownMenuItem<String>(
                          value: purpose,
                          child: Text(purpose),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPurpose = value;
                    // selectedPurpose değiştiğinde currentOptions'ı güncelle
                    if (selectedPurpose != null) {
                      if (selectedPurpose == 'Game') {
                        currentOptions = gameOptions;
                      } else if (selectedPurpose == 'Talk') {
                        currentOptions = talkOptions;
                      } else if (selectedPurpose == 'Need Help') {
                        currentOptions = helpOptions;
                      } else {
                        currentOptions = talkOptions;
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Purpose',
                  labelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                validator: _validationHomePage,
                value: selectedHobby,
                items: currentOptions
                    .map((hobby) => DropdownMenuItem<String>(
                          value: hobby,
                          child: Text(hobby),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedHobby = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Hobbies',
                  labelStyle: TextStyle(color: Colors.blue),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _selectStartTime(context);
                },
                child: Text('Select Available Start Time'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _selectFinishTime(context);
                },
                child: Text('Select Available Finish Time'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _performMatching();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Match',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );  
  }
}