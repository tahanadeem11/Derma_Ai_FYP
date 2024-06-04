import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heal_wiz_application/Screens/Dependencies/ResultScreen.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreenParent extends StatefulWidget {
  final File image;

  ResultScreenParent({required this.image});

  @override
  _ResultScreenParentState createState() => _ResultScreenParentState();
}

class _ResultScreenParentState extends State<ResultScreenParent> {
  Map<String, dynamic> responseData = {};
  String geminiResponse = '';
  bool geminiProcessing = false;
  bool isLoading = false;
  final Map<String,dynamic> healthData = {}; // Example health data

  @override
  Widget build(BuildContext context) {
    return ResultScreen(
      healthData: healthData,
      geminiProcessing: geminiProcessing,
      geminiResponse: geminiResponse,
      responseData: responseData,
      isLoading: isLoading,
      image: widget.image,
    );
  }
}
