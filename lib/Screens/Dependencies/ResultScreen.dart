import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatelessWidget {
  final Map<String,dynamic> healthData;
  final File image;
  Map<String, dynamic> responseData = {};
  String geminiResponse = ''; // Variable to hold Gemini's response
  bool geminiProcessing = false; // Variable to track Gemini processing state
  bool isLoading = false;

  ResultScreen(
      {required this.healthData,
      required this.geminiProcessing,
      required this.geminiResponse,
      required this.responseData,
      required this.isLoading,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to the color you want
        ),
        backgroundColor: Color(0xFF43A1D4),
        title: Text('Result', style: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontSize: 27,
          fontWeight: FontWeight.w600,
        ).copyWith(fontSize: 27),),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Image(
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: FileImage(image),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Analysis Results:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Your results will appear here:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,

                            color: Colors.black,
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              CircularPercentIndicator(
                                animation: true,
                                animationDuration: 2000,
                                radius: 80.0,
                                lineWidth: 12.0,
                                percent: healthData.isNotEmpty
                                    ? double.tryParse(
                                    responseData['accuracy'] ??
                                        '0.0')! /
                                    100.0
                                    : 0.0,
                                center: Text(
                                  healthData.isNotEmpty
                                      ? "${double.tryParse(responseData['accuracy'] ?? '0.0')}%"
                                      : "0.0%",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                progressColor: Colors.blue,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),
                        Stack(
                          children: [
                            Visibility(
                              visible: isLoading,
                              child: Lottie.asset(
                                "assets/animation2.json",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),

                            ),
                            Visibility(
                              visible: !isLoading,

                              child: Text(
                                healthData.isNotEmpty
                                    ? healthData.toString()
                                    : 'We are this accurate with our response',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),


                  ),
                ),
              ),
               SizedBox(height: 20),
              Center(
                child: SingleChildScrollView(
                  child: NeumorphicButton(
                    borderRadius: 12,
                    bottomRightShadowBlurRadius: 15,
                    bottomRightShadowSpreadRadius: 10,
                    borderWidth: 3,
                    backgroundColor: Colors.white,
                    topLeftShadowBlurRadius: 15,
                    topLeftShadowSpreadRadius: 1,
                    topLeftShadowColor: Colors.white,
                    bottomRightShadowColor: Colors.grey.shade500,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(50),
                    bottomRightOffset: const Offset(4, 4),
                    topLeftOffset: const Offset(-4, -4),
                    onTap: () {},
                    child: Container(

                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Let\'s see what Gemini says:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Loading indicator for Gemini processing
                            if (geminiProcessing)
                              Lottie.asset("assets/animation.json"),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              geminiProcessing
                                  ? 'Gemini will respond shortly...'
                                  : geminiResponse.isNotEmpty
                                  ? geminiResponse
                                  : 'Gemini results will appear here',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
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
