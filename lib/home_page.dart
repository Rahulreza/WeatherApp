import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Position position;
  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forecastMap;

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longatute = position.longitude;
    });
    fetchWeatherData();
  }

  var latitude;
  var longatute;

  fetchWeatherData() async {
    String forecastUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longatute&units=metric&appid=f92bf340ade13c087f6334ed434f9761&fbclid=IwAR2MIhWnKnisutHJ1y1dgxc-XbFFbVlG_T_f8F9_fhd6ZFC4PRI3oNAWgMc";

    String weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longatute&units=metric&appid=f92bf340ade13c087f6334ed434f9761&fbclid=IwAR2MIhWnKnisutHJ1y1dgxc-XbFFbVlG_T_f8F9_fhd6ZFC4PRI3oNAWgMc";

    var weatherResponce = await http.get(Uri.parse(weatherUrl));

    var forecastResponce = await http.get(Uri.parse(forecastUrl));
    weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponce.body));
    forecastMap = Map<String, dynamic>.from(jsonDecode(forecastResponce.body));
    setState(() {});
    print("eeeeeeeeeee${forecastMap!["cod"]}");
  }

  @override
  void initState() {
    // TODO: implement initState
    determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: forecastMap != null
          ? Scaffold(
              body: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          Text(
                              "${Jiffy(DateTime.now()).format("MMM do yy")} , ${Jiffy(DateTime.now()).format("h:mm")}"),
                          Text("${weatherMap!["name"]}")
                        ],
                      ),
                    ),
                    Text(
                      "${weatherMap!["main"]["temp"]} °",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(children: [
                        Text("Feels Like ${weatherMap!["main"]["feels_like"]}"),
                        Text("${weatherMap!["weather"][0]["description"]}")
                      ]),
                    ),
                    Text(
                        "Humidity ${weatherMap!["main"]["humidity"]}, Pressure ${weatherMap!["main"]["pressure"]}"),
                    Text(
                        "Sunrise ${Jiffy("${DateTime.fromMicrosecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)}").format("h:mm a")} , Sunset ${Jiffy("${DateTime.fromMicrosecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)}").format("h:mm a")}"),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: forecastMap!.length,
                          itemBuilder: (context, index) {
                            var x = forecastMap!["list"][index]["weather"][0]
                                ["icon"];
                            return Container(
                              width: 200,
                              child: Column(
                                children: [
                                  Text(
                                      "${Jiffy(forecastMap!["list"][index]["dt_txt"]).format("EEE h:mm")}"),
                                  Text(
                                      "${forecastMap!["list"][index]["main"]["temp_min"]}  ${forecastMap!["list"][index]["main"]["temp_max"]} °  "),
                                  Image.network(
                                      "http://openweathermap.org/img/wn/$x@2x.png"),
                                  Text(
                                      "${forecastMap!["list"][index]["weather"][0]["description"]}")
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
