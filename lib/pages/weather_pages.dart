import 'package:aidreamteller/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String _apiKey = API_WEATHER_KEY;
  final TextEditingController _cityController = TextEditingController(text: 'London');

  bool _isLoading = false;
  Map<String, dynamic>? _weatherData;
  List<dynamic>? _forecastData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Fetch weather for default city on startup
    _getWeatherData(_cityController.text);
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _getWeatherData(String city) async {
    if (city.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a city name";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current weather
      final weatherResponse = await http.get(
          Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric')
      );

      // Get forecast
      final forecastResponse = await http.get(
          Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey&units=metric')
      );

      if (weatherResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        setState(() {
          _weatherData = json.decode(weatherResponse.body);
          final forecastRaw = json.decode(forecastResponse.body);
          _forecastData = forecastRaw['list'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to load weather data: ${weatherResponse.reasonPhrase}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: $e";
        _isLoading = false;
      });
    }
  }

  String _getBackgroundImage(String mainWeather) {
    switch (mainWeather.toLowerCase()) {
      case 'clear':
        return 'assets/images/clear.jpg';
      case 'clouds':
        return 'assets/images/cloudy.jpg';
      case 'rain':
      case 'drizzle':
        return 'assets/images/rainy.jpg';
      case 'thunderstorm':
        return 'assets/images/storm.jpg';
      case 'snow':
        return 'assets/images/snow.jpg';
      case 'mist':
      case 'fog':
      case 'haze':
        return 'assets/images/foggy.jpg';
      default:
        return 'assets/images/default.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Weather",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 20,
                      right: 20,
                      top: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Search City',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            hintText: "Enter city name",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.location_city),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _getWeatherData(_cityController.text);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text('Search'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _getWeatherData(_cityController.text),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _errorMessage != null
          ? Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : _weatherData != null
          ? Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              _getBackgroundImage(_weatherData!['weather'][0]['main']),
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _weatherData!['name'],
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  DateFormat('EEEE, d MMMM').format(DateTime.now()),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _getWeatherIcon(_weatherData!['weather'][0]['main'], 40),
                                Text(
                                  _weatherData!['weather'][0]['description'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Text(
                          "${_weatherData!['main']['temp'].toStringAsFixed(1)}°",
                          style: const TextStyle(
                            fontSize: 85,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Feels like ${_weatherData!['main']['feels_like'].toStringAsFixed(1)}°",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _infoColumn(
                                  Icons.water_drop,
                                  "${_weatherData!['main']['humidity']}%",
                                  "Humidity"
                              ),
                              _divider(),
                              _infoColumn(
                                  Icons.air,
                                  "${_weatherData!['wind']['speed'].toStringAsFixed(1)} m/s",
                                  "Wind"
                              ),
                              _divider(),
                              _infoColumn(
                                  Icons.compress,
                                  "${_weatherData!['main']['pressure']} hPa",
                                  "Pressure"
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        if (_forecastData != null) _buildForecastSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : const Center(child: Text("No data available")),
    );
  }

  Widget _divider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white38,
    );
  }

  Widget _infoColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastSection() {
    // Group forecast by day
    Map<String, List<dynamic>> groupedForecast = {};

    for (var item in _forecastData!) {
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final day = DateFormat('yyyy-MM-dd').format(date);

      if (!groupedForecast.containsKey(day)) {
        groupedForecast[day] = [];
      }

      groupedForecast[day]!.add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const Text(
      "Hourly Forecast",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    const SizedBox(height: 16),
    SizedBox(
    height: 120,
    child: ListView.builder(
    physics: const BouncingScrollPhysics(),
    scrollDirection: Axis.horizontal,
    itemCount: _forecastData!.take(8).length,
    itemBuilder: (context, index) {
    final forecast = _forecastData![index];
    final time = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
    final temp = forecast['main']['temp'];
    final weather = forecast['weather'][0]['main'];

    return Container(
    margin: const EdgeInsets.only(right: 16),
    padding: const EdgeInsets.all(12),
    width: 80,
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    DateFormat('ha').format(time),
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    _getWeatherIcon(weather, 30),
    Text(
    "${temp.toStringAsFixed(1)}°",
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    );
    },
    ),
    ),
    const SizedBox(height: 30),
    const Text(
    "Next Days",
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    const SizedBox(height: 16),
    Column(
    children: groupedForecast.entries.take(5).map((entry) {
    // Skip today
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (entry.key == today) return const SizedBox.shrink();

    // Use noon forecast as daily representation
    final dayForecast = entry.value.firstWhere(
    (item) {
    final time = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
    return time.hour >= 12 && time.hour <= 14;
    },
    orElse: () => entry.value.first,
    );

    final date = DateTime.fromMillisecondsSinceEpoch(dayForecast['dt'] * 1000);
    final temp = dayForecast['main']['temp'];
    final weather = dayForecast['weather'][0]['main'];

    return Container(
    margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEEE').format(date),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              _getWeatherIcon(weather, 25),
              const SizedBox(width: 8),
              Text(
                "${temp.toStringAsFixed(1)}°",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    }).toList(),
    ),
      ],
    );
  }

  Widget _getWeatherIcon(String mainWeather, double size) {
    IconData iconData;
    Color iconColor;

    switch (mainWeather.toLowerCase()) {
      case 'clear':
        iconData = Icons.wb_sunny;
        iconColor = Colors.amber;
        break;
      case 'clouds':
        iconData = Icons.cloud;
        iconColor = Colors.white;
        break;
      case 'rain':
      case 'drizzle':
        iconData = Icons.water_drop;
        iconColor = Colors.lightBlue;
        break;
      case 'thunderstorm':
        iconData = Icons.flash_on;
        iconColor = Colors.yellowAccent;
        break;
      case 'snow':
        iconData = Icons.ac_unit;
        iconColor = Colors.white;
        break;
      case 'mist':
      case 'fog':
      case 'haze':
        iconData = Icons.cloud;
        iconColor = Colors.white70;
        break;
      default:
        iconData = Icons.wb_sunny;
        iconColor = Colors.amber;
    }

    return Icon(
      iconData,
      size: size,
      color: iconColor,
    );
  }
}