import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/helper_function.dart';
import 'package:weather_app/pages/settingsPage.dart';
import 'package:weather_app/weather_provider.dart';

import '../constants.dart';

class WeatherHome extends StatefulWidget {
  static const String routeName = '/';

  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherProvider _provider;
  bool _isInit = true;
  late StreamSubscription<List<ConnectivityResult>> subscription;

  bool _showDelayText = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showDelayText = true;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
      if (_isInit) {
        _provider = Provider.of<WeatherProvider>(context);
        //_getPosition();
        isConnectedToInternet().then((value) {
          if (value) {
            _getPosition();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(
                SnackBar(content: const Text('No internet again Available')));
          }
        });
        subscription = Connectivity().onConnectivityChanged.listen((
            List<ConnectivityResult> result) {
          if (result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi) {
            _getPosition();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(
                SnackBar(content: const Text('No internet Available')));
          }
        });
      }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void _getPosition() {
    determinePosition().then((position) {
      setState(() {
        final latitude = position.latitude;
        final longitude = position.longitude;
        _provider.setNewLatLng(latitude, longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text("Weather App", style: txtAppbarStyle),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
              onPressed: (){
                _getPosition();
              },
              icon: Icon(Icons.my_location,color: Colors.white,),
          ),
          IconButton(
              onPressed: () async{
                final result = await showSearch(
                    context: context,
                    delegate: _CitySearchDelegate());
                print(result);
                if(result != null){
                  _convertCityToLatLng(result);
                }
              },
              icon: Icon(Icons.search,color: Colors.white,),
          ),
          IconButton(
              onPressed: () => Navigator.pushNamed(context, Settingspage.routeName),
              icon: Icon(Icons.settings,color: Colors.white,),
          ),
        ],
      ),
      body: _provider.hasDataLoaded
          ? ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            _currentSection(),
            SizedBox(width: 20,),
            Text('This weeks weather:', style: txtTmpNorStyle,),
            _forecastSection(),
            
          ],
      )
          : Center(
        child: SizedBox(
          width: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(strokeWidth: 6),
              const SizedBox(height: 16),
              AnimatedOpacity(
                opacity: _showDelayText ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: Column(
                  children: const [
                    Text('If it takes too much time to load'),
                    Text('Please check your internet connection and'),
                    Text('then try to press "My Location" (top right)'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currentSection() {
    return Column(
      children: [
        Text(getFormattedDate(_provider.currentResponse!.dt!, 'dd MMM, yyyy   hh:mm a'), style: txtDateTime,),
        Text('${_provider.currentResponse!.name},  ${_provider.currentResponse!.sys!.country}', style: txtCountryName,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('$iconPrefix${_provider.currentResponse!.weather![0].icon}$iconSuffix',width: 100,height: 100,),
            Text('${_provider.currentResponse!.main!.temp!.round()}\u00B0',style: txtTmpBigStyle,),
          ],
        ),
        Text('${_provider.currentResponse!.weather![0].description}',style: txtTmpNatureStyle,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_upward,color: Colors.red,),
            Text(' ${_provider.currentResponse!.main!.tempMax!.round()}\u00B0',style: txtTmpNorStyle,),
            SizedBox(width: 20,),
            Icon(Icons.arrow_downward_rounded,color: Colors.greenAccent,),
            Text(' ${_provider.currentResponse!.main!.tempMin!.round()}\u00B0',style: txtTmpNorStyle,),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: Column(
                          children: [
                            Icon(Icons.air,size: 40,color: Colors.white70,),
                            Text(' ${_provider.currentResponse!.wind!.speed!.round()*3.6} km/h',style: txtWindSpeedStyle,),
                            Text('Wind',style: txtWindSpeedStyle.copyWith(fontSize: 15),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: Column(
                          children: [
                            Icon(Icons.thermostat_outlined,size: 40,color: Colors.orangeAccent,),
                            Text(' ${_provider.currentResponse!.main!.feelsLike!.round()}\u00B0',style: txtWindSpeedStyle,),
                            Text('Feels like',style: txtWindSpeedStyle.copyWith(fontSize: 15),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        child: Column(
                          children: [
                            Icon(Icons.water_drop_outlined,size: 30,color: Colors.blueAccent,),
                            Text(' ${_provider.currentResponse!.main!.humidity}%',style: txtWindSpeedStyle,),
                            Text('Humidity',style: txtWindSpeedStyle.copyWith(fontSize: 15),),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: Column(
                          children: [
                            Icon(Icons.sunny,size: 40,color: Colors.redAccent,),
                            Text(getFormattedDate(_provider.currentResponse!.sys!.sunrise!, 'hh:mm a'),style: txtWindSpeedStyle,),
                            Text('Sunrise',style: txtWindSpeedStyle,),
                          ],
                        ),
                      ),
                      SizedBox(width: 30,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: Column(
                          children: [
                            Icon(Icons.sunny_snowing,size: 40,color: Colors.blueGrey,),
                            Text(getFormattedDate(_provider.currentResponse!.sys!.sunset!, 'hh:mm a'),style: txtWindSpeedStyle,),
                            Text('Sunset',style: txtWindSpeedStyle,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget _forecastSection() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 230,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          }
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _provider.forecastResponse!.list!.length,
          itemBuilder: (context, index){
            final item = _provider.forecastResponse!.list![index];
            return Container(
              width: 120,
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(getFormattedDate(item.dt!, 'EEEE'),style: txtForecastDtStyle,),
                      Text(getFormattedDate(item.dt!, 'hh:mm a '),style: txtForecastDtStyle,),
                      Image.network('$iconPrefix${item.weather!.first.icon}$iconSuffix',width: 50,height: 50,),
                      Text('${item.main!.temp!.round()}\u00B0',style: txtForecastDtStyle.copyWith(fontSize: 25),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.water_drop_outlined,size: 30,color: Colors.blueAccent,),
                              Text('${item.main!.humidity }%',style: txtForecastDtStyle.copyWith(fontSize: 15),),
                            ],
                          ),
                          SizedBox(width: 8,),
                          Column(
                            children: [
                              Icon(Icons.air,size: 30,color: Colors.white70,),
                              Text(' ${item.wind!.speed!.round()*3.6}',style: txtForecastDtStyle.copyWith(fontSize: 15),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /*void _convertCityToLatLng(String result) async{
    try{
      final locationList = await locationFromAddress(result);
      print(locationList.length);
      if(locationList.isNotEmpty){
        final location = locationList.first;
        _provider.setNewLatLng(location.latitude, location.longitude);
      }
    }catch(error){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text('Invalid city')));
      print('Error converting city to LatLng: $error');
      //throw error;
    }
  }*/
  Future<void> _convertCityToLatLng(String result) async {
    try {
      final locationList = await locationFromAddress(result);
      if (locationList.isNotEmpty) {
        final location = locationList.first;
        _provider.setNewLatLng(location.latitude, location.longitude);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('City not found')));
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid city')));
      }
      print('Error converting city to LatLng: $error');
    }
  }

}

class _CitySearchDelegate extends SearchDelegate<String>{

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: (){
        close(context, query);
      },
      icon: Icon(Icons.arrow_back),
    );
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.saved_search),
      title: Text(query),
      onTap: (){
        close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String>filteredList = query.isEmpty ? cities :
      cities.where((city) => city.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView(
      children: filteredList.map((city) => ListTile(
        onTap: () {
          query = city;
          close(context, query);
        },
        title: Text(city),
      )).toList(),
    );
  }
  
}


