import 'dart:async';

import 'package:day36/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                WeatherPage()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,

      body: Container(
height: MediaQuery.of(context).size.height,
width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg.png"), fit: BoxFit.cover)),


        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Weather App",style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.bold),),
            Image.asset("images/icon.png",height: 150,width: 150,),
            SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
    decoration: BoxDecoration(
    color: index.isEven ? Colors.grey : Colors.white,
    ),
    );
    },
    ),
          ],
        ),
      )
      ,
    );
  }
}
