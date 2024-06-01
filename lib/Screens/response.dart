import 'dart:convert';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heal_wiz_application/Screens/Dependencies/ResultScreen.dart';
import 'package:heal_wiz_application/Screens/homePage.dart';
import 'package:heal_wiz_application/Screens/profile.dart';
import 'package:get/get.dart';
import 'Rashes.dart';
import 'appointments.dart';
import 'login.dart';

class ResponseData extends StatefulWidget {
  ResponseData({
    Key? key,
  }) : super(key: key);

  @override
  State<ResponseData> createState() => _ResponseDataState();
}

class _ResponseDataState extends State<ResponseData> {
  String _healthData = ''; // Variable to hold health data from API
  bool _isLoading = false;
  String _error = '';
  File? _selectedImage; // Variable to hold the selected image file
  bool _geminiProcessing = false; // Variable to track Gemini processing state
  String _userName = ''; // Variable to hold user's first name
  Map<String, dynamic> _responseData =
      {}; // Define responseData at the class level
  String _geminiResponse = ''; // Variable to hold Gemini's response

  @override
  void initState() {
    super.initState();
    _loadUserData();
    Gemini.init(apiKey: 'AIzaSyC__VHtj6Bs5f924VbJn84F_fOz8dfNUyc');
  }

  Future<void> _loadUserData() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Get the user document from Firestore
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .get();

        // Check if the widget is still mounted before updating the state
        if (mounted) {
          // Get the user's name field from the document
          setState(() {
            _userName = snapshot['name'];
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }

  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? name = user?.email;
    List<String> parts = name!.split("@");
    String displayName = parts[0] != null
        ? (parts[0].length <= 10 ? parts[0] : parts[0].substring(0, 10) + "...")
        : "";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF43A1D4),
        title: Text(
          displayName!.isNotEmpty ? 'Hello, ${displayName}!' : 'Hello!',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w600,
          ).copyWith(fontSize: 27),
        ),
        leading: PopupMenuButton(
          icon: Icon(Icons.menu, size: 40, color: Colors.white),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFF00557D),
                  border: Border.all(color: Colors.grey), // Set border color
                  borderRadius: BorderRadius.circular(10), // Set border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                // Add padding for spacing
                child: Text(
                  "Home",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              value: "home",
            ),
            PopupMenuItem(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFF00557D),
                  border: Border.all(color: Colors.grey), // Set border color
                  borderRadius: BorderRadius.circular(10), // Set border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                // Add padding for spacing
                child: Text(
                  "New Scan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              value: "newScan",
            ),
            PopupMenuItem(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFF00557D),
                  border: Border.all(color: Colors.grey), // Set border color
                  borderRadius: BorderRadius.circular(10), // Set border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                // Add padding for spacing
                child: Text(
                  "Your Scan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              value: "yourScan",
            ),
            PopupMenuItem(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFF00557D),
                  border: Border.all(color: Colors.grey), // Set border color
                  borderRadius: BorderRadius.circular(10), // Set border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                // Add padding for spacing
                child: Text(
                  "Rashes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              value: "rashes",
            ),
            PopupMenuItem(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFF00557D),
                  border: Border.all(color: Colors.grey), // Set border color
                  borderRadius: BorderRadius.circular(10), // Set border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                // Add padding for spacing
                child: Text(
                  "Appointment",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              value: "appointment",
            ),
            PopupMenuItem(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFF00557D),
                  border: Border.all(color: Colors.grey), // Set border color
                  borderRadius: BorderRadius.circular(10), // Set border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                // Add padding for spacing
                child: Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              value: "profile",
            ),
            PopupMenuItem(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFF00557D),
                  border: Border.all(color: Colors.grey), // Set border color
                  borderRadius: BorderRadius.circular(10), // Set border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                // Add padding for spacing
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              value: "logout",
            ),
          ],
          onSelected: (value) {
            // Handle menu item selection here
            switch (value) {
              case "home":
                // Handle profile button click
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
                break;
              case "newScan":
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResponseData()),
                );
                break;
              case "yourScan":
                // Handle button 2 click
                break;
              case "rashes":
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Rashes()),
                );
                break;
              case "appointment":
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Appointments()),
                );
                break;
              case "profile":
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
                break;
              case "logout":
                logout();
                break;
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFF43A1D4),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withOpacity(0.3), // Shadow color
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: MaterialButton(
                          color: Colors.white,
                          child: const Text(
                            "Upload File",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                              _error = '';
                            });
                            await pickfiles();
                            setState(() {
                              _isLoading = false;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _isLoading
                            ? 'Loading...'
                            : (_error.isNotEmpty
                                ? 'Error: $_error'
                                : 'Please upload an image'),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF43A1D4),
                      disabledForegroundColor: Colors.grey,
                      disabledBackgroundColor: Colors.grey,
                      side: const BorderSide(
                        color: Color(0xFF43A1D4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_selectedImage == null) {
                        Get.snackbar(
                          "Error",
                          "Please select an image to proceed.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          borderRadius: 10,
                          margin: EdgeInsets.all(10),
                          duration: Duration(seconds: 3),
                          isDismissible: true,
                          forwardAnimationCurve: Curves.easeOutBack,
                        );
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => (ResultScreen(
                          healthData: _healthData,
                          responseData: _responseData,
                          geminiProcessing: _geminiProcessing,
                          geminiResponse: _geminiResponse,
                          isLoading: _isLoading,
                          image: _selectedImage!,
                        ))));


                        print((ResultScreen(
                          healthData: _healthData,
                          responseData: _responseData,
                          geminiProcessing: _geminiProcessing,
                          geminiResponse: _geminiResponse,
                          isLoading: _isLoading,
                          image: _selectedImage!,
                        )));
                      }
                    },
                    child: Padding(
                      padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.2,),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Result"),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.2,
                          ),
                          Image.asset(
                            "assets/IconsHomePage/fastForward.png",
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  logout() async {
    // Functionality to sign out
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  Future<void> pickfiles() async {
    // Reset older data and Gemini response
    setState(() {
      _healthData = '';
      _geminiResponse = '';
      _error = '';
    });
    // Step 1: Select the media file
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.media);

    if (result != null) {
      File file = File(result.files.single.path ?? "");
      // Store the selected image file
      setState(() {
        _selectedImage = file;
      });
      try {
        // Read the file as bytes
        List<int> imageBytes = await file.readAsBytes();

        // Encode the image bytes to base64
        String base64Image = base64Encode(imageBytes);
        print('Base64 URL: $base64Image');
        // Step 3: Share base64 encoded image to API
        await _shareDataToAPI(base64Image);
      } catch (e) {
        print('Error encoding image to base64: $e');
        setState(() {
          _error = 'Error encoding image to base64';
        });
      }
    }
  }
  Future<void> _shareDataToAPI(String base64Image) async {
    try {
      // Step 4: Share base64 encoded image to API
      Dio dio = Dio();
      dio.options.connectTimeout = Duration(seconds: 5); // 5000 milliseconds
      dio.options.receiveTimeout = Duration(minutes: 5); // 300000 milliseconds

      var body = {'url': base64Image}; // Data to send in the body

      final response = await dio.post(
        'https://healwiz-backend.onrender.com/predict_skin',
        data: body, // Specify the data object
      );

      if (response.statusCode == 200) {
        print('Image data shared to API successfully');
        print('API Response: ${response.data}');

        // Parse the JSON response and extract required parameters
        _responseData = response.data; // Update the responseData
        String disease = _responseData['disease'] ?? 'N/A';
        String prescription = _responseData['medicine'] ?? 'N/A';
        String accuracy = _responseData['accuracy'] ?? 'N/A';

        setState(() {
          _healthData =
          'Disease: $disease\nPrescription: $prescription\nAccuracy: $accuracy';
        });

        // Send disease information to Gemini for reply
        if (disease != 'N/A') {
          await _sendToGemini(disease);
        }
      } else {
        print('Failed to share image data to API');
        setState(() {
          _error = 'Failed to share image data to API';
        });
      }
    } catch (e) {
      print('Error sharing data to API: $e');
      setState(() {
        _error = 'Error sharing data to API';
      });
    }
  }


  Future<void> _sendToGemini(String disease) async {
    try {
      // Set Gemini processing state to true when sending data
      setState(() {
        _geminiProcessing = true;
      });

      final gemini = Gemini.instance;

      gemini.text("$disease").then((value) {
        // Print the response to the console
        print(value?.output);

        setState(() {
          _geminiResponse = value?.output ?? 'No response from Gemini';
          _geminiProcessing =
              false; // Set processing state to false after response
        });
      }).catchError((e) {
        // Handle errors
        print(e);
        setState(() {
          _geminiProcessing = false; // Set processing state to false on error
        });
      });
    } catch (e) {
      print('Error sending data to Gemini: $e');
      setState(() {
        _geminiProcessing = false; // Set processing state to false on error
      });
    }
  }
}
