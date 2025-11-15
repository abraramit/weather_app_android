import 'package:flutter/material.dart';

const String weatherApiKey = 'weatherapikey';
const String iconPrefix = 'https://openweathermap.org/img/wn/';
const String iconSuffix = '@2x.png';

const cities = ['Abu Dhabi','Amsterdam','Bangkok','Chittagong','Calgary','Dhaka','Dubai','Hong Kong,China','Istanbul',
  'London','Los Angeles','New York','New Delhi','Paris','Singapore','Sydney','Tokyo','Toronto'];

const txtAppbarStyle = TextStyle(
  fontSize: 35,
  color: Colors.white,
  letterSpacing: 2,
  fontFamily: 'SpaceMono',
);

const txtDateTime = TextStyle(
  fontSize: 20,
  color: Colors.deepOrangeAccent,
  //color: Color(0xFFB71C1C),
  letterSpacing: 1,
  fontWeight: FontWeight.bold,
);

const txtCountryName = TextStyle(
  fontSize: 25,
  color: Colors.white,
  letterSpacing: 2,
);

const txtTmpNatureStyle = TextStyle(
  fontSize: 25,
  color: Colors.white,
);

const txtWindSpeedStyle = TextStyle(
  fontSize: 15,
  color: Colors.white,
);

const txtTmpBigStyle = TextStyle(
  fontSize: 80,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const txtTmpNorStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
);

const txtForecastDtStyle = TextStyle(
  fontSize: 15,
  color: Colors.white,
);