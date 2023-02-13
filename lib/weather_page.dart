import 'dart:convert';
import 'package:day36/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jiffy/jiffy.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
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
              backgroundColor: Colors.indigoAccent,
              body: SingleChildScrollView(
                padding: EdgeInsets.all(12),
                scrollDirection: Axis.vertical,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40,
                          ),
                          Column(
                            children: [
                              Text(
                                "${weatherMap!["name"]}",
                                style: TextStyle(
                                    fontSize: 28, color: Colors.white),
                              ),
                              Text(
                                  "${Jiffy(DateTime.now()).format("MMM do yy")} , ${Jiffy(DateTime.now()).format("h:mm a")}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                            ],
                          ),
                          Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 40,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${weatherMap!["main"]["temp"]} °C",
                              style:
                                  TextStyle(fontSize: 40, color: Colors.white),
                            ),
                            Text(
                              "${weatherMap!["weather"][0]["description"]}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Container(
                              height: 25,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white38),
                              child: Center(
                                  child: Text(
                                "Feels Like ${weatherMap!["main"]["feels_like"]}°",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width / .75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white38),
                        child: Center(
                            child: Text(
                          "Todays Forecast",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: EdgeInsets.all(12),
                          height: MediaQuery.of(context).size.height / 2.5,
                          width: MediaQuery.of(context).size.width / .75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white38),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.sunny,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      Text(
                                        "Sunrise ${Jiffy("${DateTime.fromMicrosecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)}").format("h:mm a")}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Real Feel",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white38),
                                  ),
                                  Text(
                                    "${weatherMap!["main"]["temp"]}°C",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Chance of Rain",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white38),
                                  ),
                                  Text(
                                    "${weatherMap!["wind"]["deg"]}%",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Wind Speed",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white38),
                                  ),
                                  Text(
                                    "${weatherMap!["wind"]["speed"]}km/h",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.sunny_snowing,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      Text(
                                        "Sunset ${Jiffy("${DateTime.fromMicrosecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)}").format("h:mm a")}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Humidity",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white38),
                                  ),
                                  Text(
                                    "${weatherMap!["main"]["humidity"]}%",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Pressure",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white38),
                                  ),
                                  Text(
                                    "${weatherMap!["main"]["pressure"]}mbar",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "UV Index",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white38),
                                  ),
                                  Text(
                                    "${weatherMap!["sys"]["country"]}",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width / .75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white38),
                        child: Center(
                            child: Text(
                          "Weekly Forecast",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 200,
                          width: MediaQuery.of(context).size.width / .15,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) => SizedBox(
                              width: 10,
                            ),
                            itemCount: forecastMap!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var x = forecastMap!["list"][index]["weather"][0]
                                  ["icon"];
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white38),
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${Jiffy(forecastMap!["list"][index]["dt_txt"]).format("EEE h:mm")}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 24)),
                                    Text(
                                        "${forecastMap!["list"][index]["main"]["temp_min"]}  ${forecastMap!["list"][index]["main"]["temp_max"]} °",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    Image.network(
                                      "http://openweathermap.org/img/w/" +
                                          forecastMap!["list"][index]["weather"][0]["icon"] +
                                          ".png",
                                      color: Colors.white,
                                      height: 75,
                                      width: 75,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "${forecastMap!["list"][index]["weather"][0]["description"]}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),

                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width / .75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white38),
                        child: Center(
                            child: Text(
                              "Developed By: Md.Rahul Reza",
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SplashScreenPage(),
    );
  }
}
